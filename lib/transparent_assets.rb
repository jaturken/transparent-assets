require 'yaml'
require 'carrierwave'
require 'uri'
require 'pathname'


module TransparentAssets

  @options = {
      :storage => :file,
      :fog_credentials => {},
      :fog_directory => '',
      :fog_host => ''
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
    return nil unless file.present? and [File, String, ActionDispatch::Http::UploadedFile].include? file.class

    case file.class
      when File
        filename = File.basename file
      when ActionDispatch::Http::UploadedFile
        filename = file.original_filename
        file = file.tempfile
      when String
        return file #TODO
    end

    if file.is_a? String
      #TODO
    else
      hsh = Digest::SHA1.hexdigest(file.read)
      static = StaticFile.find_or_create_by_checksum(hsh).tap do |record|
        record.filename = filename
        record.file = file if record.new_record?
      end
      static.save if static.new_record?
      return static.file.url
    end

  end

  def convert_absolute_urls_to_uids(string)
    URI.extract(string).map do |absolute_url|
      if absolute_url.match(TransparentAssets.config[:fog_host])
        file = Pathname.new(absolute_url)
        uid = file.basename.sub(file.extname, '').to_s
        string.gsub!(absolute_url, uid)
      end
    end
    string
  end


  def uids_to_absolute_urls(string)
    uids = string.scan(/[src] *= *[\"\']{0,1}([^\"\'\ >]*)/).map(&:first)
    uids.map do |uid|
      record = StaticFile.find_by_checksum(uid)
      string.gsub!(uid, record.file.url) if record.present?
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
      define_method(column){  uids_to_absolute_urls(send(:read_attribute, column))  }
      define_method("#{column}=") { |value| send(:write_attribute, column, convert_absolute_urls_to_uids(value)) }
    end


  end

end

module TransparentAssets
  class InvalidOptionsError < ArgumentError
  end

  class UnknownOptionError < ArgumentError
  end
end
