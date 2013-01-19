require "uuid"

module TransparentAssets

  def self.test
    "Transparent Assets gem."
  end

  def self.generate_uuid
    uuid = UUID.new
    uuid.generate
  end

end
