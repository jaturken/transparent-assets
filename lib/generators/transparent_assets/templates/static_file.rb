
class StaticFile < ActiveRecord:: Base
  attr_accessible :file, :filename, :checksum
  mount_uploader :file, TransparentAssetUploader
end
