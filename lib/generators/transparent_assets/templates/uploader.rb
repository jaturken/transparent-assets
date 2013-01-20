# encoding: utf-8

class TransparentAssetUploader < CarrierWave::Uploader::Base


  self.configure do |config|
    config.storage = TransparentAssets.config[:storage]
    config.fog_credentials = TransparentAssets.config[:fog_credentials].symbolize_keys
    config.fog_directory = 'transparent-assets'
    #config.asset_host = TransparentAssets.config[:fog_host]
  end

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "transparent_assets/#{model.id}"
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    [TransparentAssets.generate_uuid.to_str,file.extension].join('.') if original_filename
  end

end
