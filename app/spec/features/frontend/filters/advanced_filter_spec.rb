require 'rails_helper'
require 'spree/testing_support/factories/product_factory'

describe 'Advanced filter', js: true do
  shared_examples 'filter by' do |blank_option, select_option, visible_products, invisible_products|
    context "filter by #{select_option}" do
      When { select2_single(blank_option, select_option) }

      include_examples 'there are all products'

      context 'submit is clicked' do
        When { find('button[type="submit"]', text: 'FILTER').click }

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
  end

  When { visit_as_adult wines_path }
  When { find('.search_open').click }

  Given(:subject) { find('.catalog') }

  context 'filtering' do
    include_examples 'one filter', 'Color', 'WINE COLOR', %w(RED WHITE), CFG.taxons.wine.children.regular.title
    include_examples 'one filter', 'Age', 'WINE AGE', ['1 YEAR', '2 YEARS'], CFG.taxons.wine.children.regular.title
    include_examples 'one filter', 'Food', "TODAY'S DINNER", %w(APPLE CHEESE), CFG.taxons.wine.children.regular.title
  end

  context 'sorting' do
    shared_examples 'products are ordered' do |ordered_products|
      context "products are ordered as #{ordered_products.inspect}" do
        Given(:expected_order) { ordered_products.map { |p| send(p) }.map(&:slug) }
        Given(:actual_order) { all('.catalog_item a', visible: false).map { |p| p[:href].split('/').last } }

        Then { expect(all('.catalog_item').count).to eq(3) }
        And  { expect(actual_order).to eq(expected_order) }
      end
    end

    Given(:submit_filter) { find('button[type="submit"]', text: 'FILTER').click }

    Given(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }
    Given(:regular_taxon) { create :taxon, name: CFG.taxons.wine.children.regular.title }

    Given(:product_1) { create :product, taxons: [regular_taxon, wine_taxon]  }
    Given(:product_2) { create :product, taxons: [regular_taxon, wine_taxon]  }
    Given(:product_3) { create :product, taxons: [regular_taxon, wine_taxon]  }

    Given(:location) { create :property, name: 'Location' }
    Given(:taste) { create :property, name: 'Taste' }
    Given(:mood) { create :property, name: 'Mood' }

    Given { create :product_property, property_id: location.id, product_id: product_1.id, value: 'Italy' }
    Given { create :product_property, property_id: location.id, product_id: product_2.id, value: 'France' }
    Given { create :product_property, property_id: location.id, product_id: product_3.id, value: 'Italy' }

    Given { create :product_property, property_id: taste.id, product_id: product_1.id, value: 'Sweet' }
    Given { create :product_property, property_id: taste.id, product_id: product_2.id, value: 'Bitter' }
    Given { create :product_property, property_id: taste.id, product_id: product_3.id, value: 'Sweet' }

    Given { create :product_property, property_id: mood.id, product_id: product_1.id, value: 'Bad' }
    Given { create :product_property, property_id: mood.id, product_id: product_2.id, value: 'Bad' }
    Given { create :product_property, property_id: mood.id, product_id: product_3.id, value: 'Good' }

    context 'order by Location' do
      When { select2_single('LOCATION', 'ITALY') }

      include_examples 'products are ordered', %w(product_1 product_2 product_3)

      context 'submit is clicked' do
        When { submit_filter }

        include_examples 'products are ordered', %w(product_1 product_3 product_2)
      end
    end

    context 'order by Location and Taste' do
      When { select2_single('TASTE PREFERENCES', 'BITTER') }
      When { select2_single('LOCATION', 'ITALY') }

      include_examples 'products are ordered', %w(product_1 product_2 product_3)

      context 'submit is clicked' do
        When { submit_filter }

        include_examples 'products are ordered', %w(product_2 product_1 product_3)
      end
    end

    context 'order by Location, Taste and Mood' do
      When { select2_single('TASTE PREFERENCES', 'BITTER') }
      When { select2_single('LOCATION', 'ITALY') }
      When { select2_single('MOOD', 'GOOD') }

      include_examples 'products are ordered', %w(product_1 product_2 product_3)

      context 'submit is clicked' do
        When { submit_filter }

        include_examples 'products are ordered', %w(product_3 product_2 product_1)
      end
    end
  end
end
