require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'Simple filter', js: true do
  shared_examples 'filter by' do |blank_option, select_option, visible_products, invisible_products|
    context "filter by #{select_option}" do
      When { select2_single(blank_option, select_option) }

      Then { expect(all('.catalog_item').count).to eq(2) }

      visible_products.each do |product|
        And { is_expected.to have_css("a[href='#{product_path(send(product))}']", visible: false) }
      end

      invisible_products.each do |product|
        And { is_expected.not_to have_css("a[href='#{product_path(send(product))}']", visible: false) }
        And { is_expected.not_to have_css("a[href='#{product_path(send(product))}']") }
      end
    end
  end

  When { visit_as_adult wines_path }

  Given(:subject) { find('.catalog') }

  include_examples 'one filter', 'Color', 'WINE COLOR', %w(RED WHITE), CFG.taxons.wine.children.regular.title
  include_examples 'one filter', 'Age', 'WINE AGE', ['1 YEAR', '2 YEARS'], CFG.taxons.wine.children.regular.title
  include_examples 'one filter', 'Food', "TODAY'S DINNER", %w(APPLE CHEESE), CFG.taxons.wine.children.regular.title
end
