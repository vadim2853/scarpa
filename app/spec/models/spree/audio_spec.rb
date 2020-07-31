require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

RSpec.describe Spree::Audio, type: :model do
  it { should validate_presence_of :description }
  it { should validate_presence_of :description_it }
  it { should validate_length_of(:title).is_at_least(2).is_at_most(255) }
  it { should validate_length_of(:title_it).is_at_least(2).is_at_most(255) }
  it { should belong_to :product }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).less_than(10.megabytes) }
  it do
    should validate_attachment_content_type(:image)
      .allowing('image/jpeg', 'image/png')
      .rejecting('text/plain', 'text/xml')
  end

  it 'should check permissible number of audios (max 2 for product)' do
    product = create :product
    2.times { create :audio, product_id: product.id }
    fail_audio = build :audio, product_id: product.id

    expect(fail_audio.save).to be_falsey
    expect(fail_audio.errors.messages[:permissible_number]).to eq ['of entries - only two!']
  end
end
