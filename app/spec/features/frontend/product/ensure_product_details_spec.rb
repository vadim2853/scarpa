require 'rails_helper'
require 'spree/testing_support/factories/option_type_factory'
require 'spree/testing_support/factories/option_value_factory'
require 'spree/testing_support/factories/variant_factory'
require 'spree/testing_support/factories/taxon_factory'

describe 'ensure product details page', js: true do
  let(:params) { { name: 'Product of Scarpa' } }
  let(:product) { create :product, params.merge(taxons: [wine_taxon]) }
  let(:wine_taxon) { create :taxon, name: CFG.taxons.wine.title }

  context 'product section' do
    before do
      bottle = create :option_type, name: 'bottle'
      crate = create :option_type, name: 'crate'

      params.merge(option_types: [bottle, crate])

      small_bottle = create :option_value, name: '0.75L', presentation: '0.75L', option_type: bottle, position: 2
      small_crate = create :option_value, name: '6x0.75L', presentation: '6 x 0.75L', option_type: crate, position: 1

      create :variant, product: product, option_values: [small_bottle], cost_price: '27'
      create :variant, product: product, option_values: [small_crate], cost_price: '160'

      Spree::Image.create(
        viewable_id: product.master.id,
        viewable_type: 'Spree::Variant',
        attachment: File.open(Rails.root.join('spec/fixtures/images/slide.jpg'))
      )
    end

    it 'should find correct default value for quantity field' do
      visit_as_adult product_path(product)

      expect(find('#order_quantity').value).to eq '1'
    end

    it 'should find product image' do
      visit_as_adult product_path(product)

      expected_url = "/spree/products/#{product.master.id}/large/slide.jpg"
      expect(find('.product_image img')['src']).to include(expected_url)
    end

    # TODO: test of video PLAYING !!!
    it 'should find video button' do
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_play-video .play-video_icon', visible: true
      expect(find('.product')['data-video-mp4']).to eq 'http://techslides.com/demos/sample-videos/small.mp4'
      expect(find('.product')['data-video-ogg']).to eq 'http://techslides.com/demos/sample-videos/small.ogg'
      expect(find('.product')['data-video-webm']).to eq 'http://techslides.com/demos/sample-videos/small.webm'
    end

    it 'should find name of product' do
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_name', text: 'Product of Scarpa', visible: true
    end

    it 'should find producer' do
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_producer', text: 'Super producer', visible: true
    end

    it 'should find geographic setting' do
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_geo', text: 'Geographic setting things', visible: true
    end

    # TODO: test of drop-down list
    it 'should find price selector' do
      visit_as_adult product_path(product)

      expect(all('.product_price select option').map(&:text)).to eq ['PER Bottle 0.75L', 'PER Crate 6 x 0.75L']
    end

    it 'should find disabled price selector for one variant' do
      product.variants.first.destroy
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_price .select2-container-disabled'
    end

    it 'should find quantity field' do
      visit_as_adult product_path(product)

      expect(page).to have_selector '.product_qty input[name="order[quantity]"]', visible: true
    end

    it 'should find "Add to cart submit"' do
      visit_as_adult product_path(product)

      expect(page).to have_selector 'form button', text: 'ADD TO CART', visible: true
    end
  end

  context 'organoleptic data section' do
    before do
      set_custom_property(
        product,
        Spree::Property.groups[:dominant_flavours],
        'dominant_flavours',
        ['iconfon-acid', 'iconfon-almond', 'iconfon-anice', 'iconfon-apricot', 'iconfon-baking_spices'],
        1,
        :icon
      )

      set_custom_property(product, Spree::Property.groups[:perfect_temperature], 'perfect_temperature', '16', 2)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'FRUITY', 0, 3)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'BODY', 1, 4)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'ALCOHOL', 2, 5)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'ACIDITY', 3, 6)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'BEAUTIFY', 4, 7)
      set_custom_property(product, Spree::Property.groups[:wine_profile], 'STATUS "LIKE A BOSS"', 5, 8)
      set_custom_property(product, Spree::Property.groups[:perfect_glass], 'pg', ['iconfon-clay_pot'], 9, :icon)
      set_custom_property(product, Spree::Property.groups[:wine_aeration], 'wine_aeration', 12, 10)

      visit_as_adult product_path(product)
    end

    specify 'dominant flavours list' do
      expect(page).to have_selector '.organoleptic_icon .iconfon-acid', visible: true
      expect(page).to have_selector '.organoleptic_icon .iconfon-almond', visible: true
      expect(page).to have_selector '.organoleptic_icon .iconfon-anice', visible: true
      expect(page).to have_selector '.organoleptic_icon .iconfon-apricot', visible: true
      expect(page).to have_selector '.organoleptic_icon .iconfon-baking_spices', visible: true
    end

    it 'should find perfect temperature' do
      expect(page).to have_content '16°С'
    end

    it 'should find wine profiles list with predefined positions' do
      expectation = ['FRUITY', 'BODY', 'ALCOHOL', 'ACIDITY', 'BEAUTIFY', 'STATUS "LIKE A BOSS"']
      expect(all('.organoleptic_name_inn').map(&:text)).to eq expectation
    end

    it 'should find perfect glass' do
      expect(page).to have_selector '.iconfon-clay_pot', visible: true
    end

    it 'should find wine aeration' do
      expect(page).to have_content '12 min.'
    end
  end

  context 'technical data section' do
    before do
      set_custom_property(product, Spree::Property.groups[:technical_data], 'GRAPE', '100% Dolcetto d’Acqui', 1)
      set_custom_property(product, Spree::Property.groups[:technical_data], 'ALCOHOL CONTENT', '12%-13%', 3)
      set_custom_property(product, Spree::Property.groups[:technical_data], 'TOTAL ACIDITY', '6 gr/lt', 2)

      visit_as_adult product_path(product)
    end

    it 'should find correct technical data list with predefined positions' do
      expected_names = ['GRAPE', 'TOTAL ACIDITY', 'ALCOHOL CONTENT']
      expect(all('.technical_data_block .technical_data__name').map(&:text)).to eq expected_names

      expected_descriptions = ['100% Dolcetto d’Acqui', '6 gr/lt', '12%-13%']
      expect(all('.technical_data_block .technical_data__description').map(&:text)).to eq expected_descriptions
    end
  end

  context 'perfect experience section' do
    let(:glass_taxon) { create :taxon, name: CFG.taxons.wine_glass.title }
    let(:wine_glass) { create :product, name: 'Burgundian glass', description: 'THE GLASS', taxons: [glass_taxon] }

    before do
      Spree::Image.create(
        viewable_id: wine_glass.master.id,
        viewable_type: 'Spree::Variant',
        attachment: File.open(Rails.root.join('spec/fixtures/images/slide.jpg'))
      )

      product.update_attribute(:wine_glass_id, wine_glass.id)
    end

    it 'should find wine glass' do
      visit_as_adult product_path(product)

      expected_url = "/spree/products/#{wine_glass.master.id}/large/slide.jpg"
      expect(find('.product_glass .product_glass__image img')['src']).to include(expected_url)
    end

    it 'should find one music block' do
      audio = create :audio, product: product
      visit_as_adult product_path(product)

      expect(all('.product_music .product_music__block').size).to eq 1
      within(:css, '.product_music') do
        expect(find('.product_music__block')['data-audio-mp3']).to eq 'test.mp3'
        expect(find('.product_music__block')['data-audio-ogg']).to eq 'test.ogg'
        expect(find('.product_music__block')['data-audio-wav']).to eq 'test.wav'
      end

      bg_expectation = "/spree/audios/#{audio.id}/images/mediums/slide.jpg"
      expect(find('.product_music__track_bg')['style']).to include(bg_expectation)
    end

    it 'should find two music blocks' do
      2.times { create :audio, product: product }
      visit_as_adult product_path(product)

      expect(all('.product_music .product_music__block').size).to eq 2
    end
  end

  context 'topics section' do
    before do
      @first_topic = create :topic, product: product, title: 'Furred Game', position: 1
      @second_topic = create :topic, product: product, title: 'Typical piedmontese agnolotti', position: 2

      visit_as_adult product_path(product)
    end

    it 'should find opened topics section' do
      expect(page).to have_selector '.pslider h5', text: 'THE RIGHT FOOD', visible: true
    end

    it 'should be two topics in slider block' do
      expect(all('.pslider_bg ul li').map(&:text)).to eq ['Furred Game', 'Typical piedmontese agnolotti']
    end

    it 'should find images for every title' do
      expected_ids = ["pslider_image_#{@first_topic.id}", "pslider_image_#{@second_topic.id}"]
      expect(all('.pslider_image img').map { |img| img['id'] }).to eq expected_ids
    end
  end

  context 'related products section' do
    before do
      3.times { ProductRelation.create(related_id: product.id, inverse_related_id: create(:product).id) }

      visit_as_adult product_path(product)
    end

    it 'should find three related products' do
      expect(all('.also_like .also_like_name', visible: true).size).to eq 3
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def set_custom_property(product, group, prop_name, prop_values, position = 1, prop_type = :default)
    ActiveRecord::Base.transaction do
      property = Spree::Property.create_with(
        presentation: prop_name,
        group: group
      ).find_or_create_by(name: prop_name, group: group)

      product_property = Spree::ProductProperty.where(
        product: product,
        property: property,
        position: position
      ).first_or_initialize

      if prop_type == :default
        product_property.value = prop_values
      else
        product_property.value_array = prop_values
      end

      product_property.save!
    end
  end
  # rubocop:enable Metrics/ParameterLists
end
