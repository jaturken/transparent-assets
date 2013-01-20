require "uuid"
require 'yaml'
require 'digest/sha1'
require 'carrierwave'
require 'uri'
require 'pathname'


module TransparentAssets

  @options = {
      :storage => :file,
      :fog_credentials => {}
  }

  def self.configure(opts={})
    opts.each{|k,v| @options[k.to_sym] = v if @options.keys.include? k.to_sym}
  end

  def self.generate_uuid
    uuid = UUID.new
    uuid.generate
  end

  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))[Rails.env]
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @options
  end


  def self.check(file)
    if file.present? and file.is_a? File
      hsh = Digest::SHA1.hexdigest(file.read)
      static = StaticFile.find_or_initialize_by_checksum(hsh).tap do |record|
        record.filename = File.basename file
        record.file = file
      end
      static.save if static.new_record?
      return static.file.url
    end
  end

  def generate_uuid
    uuid = UUID.new
    uuid.generate
  end

  def global_urls_to_uids(string)
    local_urls = URI.extract(string)
    local_urls.map do |local_url|
      uid = Pathname.new(local_url).basename.to_s.sub(/.jp(|e)g/, '')
      partitioned_string = string.rpartition(local_url)
      string = partitioned_string.first + "'#{uid}'" + partitioned_string.first
    end
    string
  end

  def uids_to_global_urls(string)
    uids = string.scan(/[src] *= *[\"\']{0,1}([^\"\'\ >]*)/).map(&:first)
    uids.map do |uid|
      partitioned_string = string.rpartition(uid)
      global_url = StaticFile.find_by_checksum(partitioned_string[1]).file.url
      string = partitioned_string.first + global_url + partitioned_string.last
    end
    string
  end

end


class << ActiveRecord::Base

  def has_transparent_assets options = {}
    raise TransparentAssets::InvalidOptionsError.new "TransparentAssets options should be a hash" unless options.is_a? Hash
    options.each do |k, v|
      unless [:observerable_columns].include? k
        raise TransparentAssets::UnknownOptionError.new "Unknown option #{k} for TransparentAssets"
      end
    end

    cattr_accessor :observerable_columns
    self.observerable_columns = options[:observerable_columns] ||= []

    include TransparentAssets

    self.observerable_columns.each do |column|
      define_method(column){  uids_to_global_urls(send(:read_attribute, column))  }
      define_method("#{column}=") { |value| send(:write_attribute, column, global_urls_to_uids(value)) }
    end


  end

end

module TransparentAssets
  class InvalidOptionsError < ArgumentError
  end

  class UnknownOptionError < ArgumentError
  end
end
