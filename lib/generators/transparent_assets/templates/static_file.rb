class StaticFile < ActiveRecord:: Base
  attr_accessible :file, :filename, :checksum
end
