class DataImportCsvService

  def initialize(data_import_id)
    @data_import = DataImport.find(data_import_id)
  end

  def execute
    return { message: "Whoops!!! Can not import files which was imported" } if @data_import.is_imported?

    @data_import.in_progress_at = Time.now
    @data_import.save
    contacts = []
    ::CSV.foreach("public/#{@data_import.link_url}", headers: true) do |row|
      contacts << Contact.new(row.to_h)
    end
    ActiveRecord::Base.transaction do
      Contact.import!(contacts)
    end
    @data_import.is_imported = true
    @data_import.save
    return { message: "Import contacts successfully!!!" }

  rescue Exception => e
    @data_import.failed_at = Time.now
    @data_import.save
    { message: "Import contacts were failed by #{e.message}" }
  end
end
