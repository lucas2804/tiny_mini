class DataImport < ApplicationRecord
  mount_uploader :link, ::DataImportUploader

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
