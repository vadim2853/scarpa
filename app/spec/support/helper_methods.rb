module HelperMethods
  def screenshot
    sleep 10

    # rubocop:disable Lint/Debugger
    save_screenshot
    # rubocop:enable Lint/Debugger
  end

  def sign_in_admin(user)
    visit spree.new_admin_featured_item_path
    fill_in Spree.t(:email), with: user.email
    fill_in Spree.t(:password), with: user.password
    click_button Spree.t(:login)
  end

  def turn_on_drag_n_drop_js
    %w(jquery.simulate.js jquery.simulate.ext.js jquery.simulate.drag-n-drop.js).each do |file|
      execute_script(File.open(Rails.root.join('spec/fixtures/js/', file), 'r').read.html_safe)
    end
  end

  def select2_single(label, option)
    find('.select2-container', text: label).click
    find('li.select2-result', text: option).click

    find('span.select2-chosen', text: option)
  end

  def product_path(p)
    Rails.application.routes.url_helpers.product_path(p)
  end

  def move_point(point_selector, distance, axis = 'x')
    execute_script("$('#{point_selector}')"\
    ".simulate('drag-n-drop', {d#{axis}: #{distance}, interpolation:{stepWidth: 10}});")
  end

  def fill_in_ckeditor(input_id, params)
    page.driver.browser.execute_script("CKEDITOR.instances['#{input_id}'].setData('#{params[:with]}');")
  end

  def visit_as_adult(path)
    visit path
    create_cookie('is_adult', true)
    visit path
  end
end
