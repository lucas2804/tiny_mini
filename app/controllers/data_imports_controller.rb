require 'csv'
class DataImportsController < ApplicationController
  def save
    @data_import = DataImport.new(data_import_params)
    if @data_import.save
      redirect_to(action: 'index')
    end
  end

  def index
    @contacts                        = Contact.ordered_by_phone_active_date
    @actual_activation_date_contacts = Contact.lastest_active_days_of_phones
    @data_imports                    = DataImport.all
  end

  def import_contact_csv
    @import_service = DataImportCsvService.new(params[:id])
    flash[:notice] = @import_service.execute[:message]
    redirect_to(action: 'index')
  end

  private

  def data_import_params
    params.require(:data_import).permit(:link)
  end

end
