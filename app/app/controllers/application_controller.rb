class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :display_coming_soon?

  private

  def redirect_to_coming_soon
    return true unless display_coming_soon?

    render "coming_soon/#{params[:controller]}_#{params[:action]}"
  end

  def display_coming_soon?
    (current_spree_user.blank? || !current_spree_user.admin?) && Spree::Config.display_coming_soon
  end

  def finalize_grade(u_id = nil, grade = nil)
    return if session[:grade_score].blank? || spree_current_user.blank?

    user_id = u_id || spree_current_user.id
    grade   = Spree::Grade.first if grade.blank?

    data = GradeService.finalize(user_id, grade, session[:grade_score])
    session[:grade_score]   = nil
    session[:grade_percent] = nil
    data
  end

  def path_after_sign_in_up
    if session[:show_certificate].present?
      session[:show_certificate] = nil
      '/cabinet?show_certificate=true'
    elsif request.referer.present?
      request.referer
    else
      '/'
    end
  end

  def percent_result(grade)
    session[:grade_percent] = GradeService.calculate_percent(grade, session[:grade_score])
  end

  def after_sign_out_path_for(_resource_or_scope)
    '/'
  end

  def signed_in_root_path(*)
    '/admin'
  end
end
