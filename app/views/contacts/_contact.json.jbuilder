json.extract! contact, :id, :activation_date, :deactivation_date, :phone_number, :created_at, :updated_at
json.url contact_url(contact, format: :json)
