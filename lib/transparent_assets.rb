require "uuid"

module TransparentAssets

  def generate_uuid
    uuid = UUID.new
    uuid.generate
  end

  def cloud_to_uids(string)
    string+'encoded'
  end

  def uids_to_cloud(string)
    'decoded'
  end

end


class << ActiveRecord::Base

  def has_transparent_assets options = {}
    raise TransparentAssets::InvalidOptionsError.new "TransparentAssets options should be a hash" unless options.is_a? Hash
    options.each do |k, v|
      unless [:observerable_columns].include? k
        raise TransparentAssets::TransparentAssetsException.new "Unknown option #{k} for TransparentAssets"
      end
    end

    cattr_accessor :observerable_columns
    self.observerable_columns = options[:observerable_columns] ||= []

    include TransparentAssets

    self.observerable_columns.each do |column|
      define_method(column){  uids_to_cloud(send(:read_attribute, column))  }
      define_method("#{column}=") { |value| send(:write_attribute, column, cloud_to_uids(value)) }
    end


  end

end

module TransparentAssets
  class InvalidOptionsError < ArgumentError
  end
end
