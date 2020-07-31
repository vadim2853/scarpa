require 'rails_helper'

RSpec.describe Spree::Winery, type: :model do
  it { should validate_presence_of :description }
  it { should validate_presence_of :description_it }
  it { should validate_length_of(:title).is_at_least(2).is_at_most(10) }
  it { should validate_length_of(:title_it).is_at_least(2).is_at_most(10) }
  it { should define_enum_for(:status).with [:draft, :published] }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).less_than(10.megabytes) }
  it do
    should validate_attachment_content_type(:image)
      .allowing('image/jpeg', 'image/png')
      .rejecting('text/plain', 'text/xml')
  end
end
