module ApplicationHelper
  def roles
    Spree::Role.where(category: 'business').map { |role| [role.description.upcase, role.id] }
  end

  def property_groups
    Spree::Property.groups.map { |key, _val| [Spree.t(key), key] }
  end

  def properties_by_group(group)
    @product.properties.where(group: Spree::Property.groups[group])
  end

  def property_values_by_group(group, value_type = :value)
    prop = properties_by_group(group).take
    return nil unless prop
    value_by_property_and_type(prop, value_type)
  end

  def value_by_property_and_type(prop, value_type)
    @product.product_properties.find_by(property: prop).try(value_type)
  end

  def icons_list
    ICONS.keys
  end

  def posted_on(entry)
    "#{Spree.t('posted_on')} : #{entry.posted_on.strftime('%^B %e, %Y')}"
  end

  def joined_on(entry)
    "#{Spree.t('joined_on')} #{entry.created_at.strftime('%^B %e, %Y')}"
  end

  def user_name_or_tooltip(mobile = false)
    user = spree_current_user
    class_if_mobile = mobile ? 'user_name_mobile' : ''

    if user.first_name.present?
      link_to user.first_name, 'javascript:;', 'data-href' => cabinet_path, class: "cabinet_link #{class_if_mobile}"
    else
      link_to '...', 'javascript:;',
              'data-href' => cabinet_path,
              class: "cabinet_link email_tooltip #{class_if_mobile}", title: user.email
    end
  end

  def available_countries
    Spree::Country.all.order(:name).collect do |country|
      country.name = Spree.t(country.iso, scope: 'country_names', default: country.name)
      country.name.parameterize
      country
    end
  end

  def user_address
    default = spree_current_user.default_address
    return if default.blank?

    [
      default.address1,
      default.zipcode,
      default.state_name || Spree::State.select(:name).where(id: default.state_id).take.try(:name),
      Spree::Country.select(:name).where(id: default.country_id).take.try(:name)
    ].reject(&:blank?).map(&:strip).join(',<br />')
  end

  def options_for_archive(model)
    options_for_select(model.archive_options.map { |d| [d.strftime('%b %Y'), d.to_s] }, params[:by_month])
  end

  def last_nomination_icon
    last_results = spree_current_user.grades_results
    image_tag(last_results&.last&.nomination&.icon(:small) || image_path('grade_bg.png'))
  end

  def circle_link_to_cart
    unless simple_current_order.nil? || simple_current_order.item_count.zero?
      link_to simple_current_order.item_count, cart_path, class: 'header_amount'
    end
  end

  def adult?
    ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(cookies[:is_adult])
  end
end
