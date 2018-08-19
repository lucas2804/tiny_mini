require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '.lastest_active_days_of_phones' do
    subject { Contact.lastest_active_days_of_phones }

    context 'current phone number was de-activated' do
      before do
        Contact.create(phone_number: '0987001', activation_date: '2016-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: '2016-05-01')
      end

      it 'should NOT invoke it' do
        expect(subject.count).to eq(0)
      end
    end

    context 'current phone number was activated' do
      before do
        Contact.create(phone_number: '0987001', activation_date: '2015-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: nil)
      end

      it 'should invoke it' do
        expect(subject.count).to eq(1)
        expect(subject.first.activation_date.to_s).to eq('2015-01-01')
      end
    end

    context 'phone number were used by 3 users' do
      before do
        # User-A
        Contact.create(phone_number: '0987001', activation_date: '2016-01-01', deactivation_date: '2016-03-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-03-01', deactivation_date: '2016-05-01')

        # User-B
        Contact.create(phone_number: '0987001', activation_date: '2016-06-01', deactivation_date: '2016-07-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-07-01', deactivation_date: '2016-08-01')

        # User-C current active user
        Contact.create(phone_number: '0987001', activation_date: '2016-08-15', deactivation_date: '2016-09-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-09-01', deactivation_date: '2016-10-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-10-01', deactivation_date: '2016-11-01')
        Contact.create(phone_number: '0987001', activation_date: '2016-11-01', deactivation_date: nil)
      end

      it 'should invoke actual activation date of User-C' do
        expect(subject.count).to eq(1)
        expect(subject.first.activation_date.to_s).to eq('2016-08-15')
      end
    end

    context 'just user-a who de-active and re-active 1 month later' do
      it 'was not covered by us' do
        # Pending........... waiting for confirmation
      end
    end
  end
end
