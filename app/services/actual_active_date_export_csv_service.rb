class ActualActiveDateExportCsvService

  HEADER = [:phone_number, :activation_date].freeze

  def self.to_csv(contacts, options = {})
    CSV.generate(options) do |csv|
      csv << HEADER
      contacts.each do |contact|
        csv << HEADER.map{ |attr| contact.send(attr) }
      end
    end
  end
end
