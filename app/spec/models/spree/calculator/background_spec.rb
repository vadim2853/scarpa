require 'rails_helper'

RSpec.describe Spree::Calculator::Background, type: :model do
  it { should validate_presence_of :event }
  it { should validate_presence_of :month }
  it { should validate_presence_of :guests }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).less_than(10.megabytes) }
  it do
    should validate_attachment_content_type(:image)
      .allowing('image/jpeg', 'image/png')
      .rejecting('text/plain', 'text/xml')
  end

  describe 'asociations' do
    it { should belong_to(:event) }
    it { should belong_to(:month) }
  end
end
