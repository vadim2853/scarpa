require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'ensure drag and drop (position of viewing)' do
  stub_authorization!

  before do
    @product = create :product

    @position_ids = []
    @position_ids << create(:audio, product_id: @product.id, title: 'First').id
    @position_ids << create(:audio, product_id: @product.id, title: 'Second').id

    visit spree.admin_product_audios_path(@product)
  end

  it 'should change positions of audios', js: true do
    selectors_ids = @position_ids.map { |id| "spree_audio_#{id}" }

    expect_table_with(selectors_ids)

    turn_on_drag_n_drop_js

    execute_script(
      "$('#spree_audio_#{@position_ids.first} .handle')"\
      ".simulate('drag-n-drop', {dy: 300, interpolation:{stepWidth: 10}});"
    )

    sleep 2

    expect_table_with(selectors_ids.reverse)

    visit spree.admin_product_audios_path(@product)

    expect_table_with(selectors_ids.reverse)
  end

  def expect_table_with(ids)
    expect(find('.audios_table').all('tbody tr').map { |tr| tr['id'] }).to eq ids
  end
end
