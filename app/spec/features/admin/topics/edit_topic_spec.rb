require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'editing of topic' do
  stub_authorization!

  before :each do
    @product = create :product
    @topic = create :topic, product_id: @product.id
  end

  it 'should visit topic editing page' do
    visit spree.admin_product_topics_path(@product)

    find(:css, 'a[data-action="edit"]').click
    expect(page).to have_content 'Editing Product'
  end

  it 'should update topic' do
    visit spree.edit_admin_product_topic_url(@product, @topic)

    expect(find('#topic_title').value).to eq 'Topic title'

    fill_in 'topic[title]', with: 'Little update for title'
    fill_in 'topic[link]', with: 'http://facebook.com'
    click_button('Update')

    expect(page).to have_content 'Topic has been successfully updated!'
    expect(page).to have_content 'Little update for title'
    expect(page).to have_content 'http://facebook.com'
  end
end
