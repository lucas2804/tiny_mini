require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        :phone_number => ""
      ),
      Contact.create!(
        :phone_number => ""
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
