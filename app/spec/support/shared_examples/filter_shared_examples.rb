require 'spree/testing_support/factories/taxon_factory'

shared_examples 'there are all products' do
  context 'there are all products' do
    Then { expect(all('.catalog_item').count).to eq(3) }
    And  { is_expected.to have_css("a[href='#{product_path(product_1)}']", visible: false) }
    And  { is_expected.to have_css("a[href='#{product_path(product_2)}']", visible: false) }
    And  { is_expected.to have_css("a[href='#{product_path(product_3)}']", visible: false) }
  end
end

shared_examples 'one filter' do |prop_name, blank_option, filter_opts, taxon_name|
  describe "#{prop_name} filter" do
    Given(:taxon) { create :taxon, name: taxon_name }
    Given(:property) { create :property, name: prop_name }
    Given(:product_1) { create :product, taxons: [taxon, wine_taxon] }
    Given(:product_2) { create :product, taxons: [taxon, wine_taxon] }
    Given(:product_3) { create :product, taxons: [taxon, wine_taxon] }
    Given(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }

    Given { create :product_property, property_id: property.id, product_id: product_1.id, value: filter_opts.first }
    Given { create :product_property, property_id: property.id, product_id: product_2.id, value: filter_opts.last }
    Given { create :product_property, property_id: property.id, product_id: product_3.id, value: filter_opts.first }
    Given { create :product_property, property_id: property.id, product_id: product_3.id, value: filter_opts.last }

    include_examples 'filter by', blank_option, filter_opts.first, %w(product_1 product_3), %w(product_2)
    include_examples 'filter by', blank_option, filter_opts.last, %w(product_2 product_3), %w(product_1)

    include_examples 'there are all products'

    context 'filter options' do
      Given(:expected_options) { [blank_option, filter_opts.first, filter_opts.last] }

      When { find('.select2-container', text: blank_option).click }

      Then { expect(all('li.select2-result').map(&:text)).to eq(expected_options) }
    end
  end
end
