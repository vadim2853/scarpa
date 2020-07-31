module GradesHelper
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def grade_data(grade, index)
    ivar_name = "@_grade_data_#{index}"

    return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

    result = if spree_current_user.present? && grade.user_result(spree_current_user.id).present?
               grade_user_result = grade.user_result(spree_current_user.id)
               icon = grade_user_result&.nomination&.icon

               {
                 percent: grade_user_result.percent,
                 icon: icon.present? ? asset_url(icon) : image_url('grade_bg.png'),
                 result_id: grade_user_result&.id
               }

             elsif session[:grade_score].present? && session[:grade_percent].present? && index == 0
               icon = GradeService.take_nomination(grade, session[:grade_score])&.icon

               {
                 percent: session[:grade_percent],
                 icon: icon.present? ? asset_url(icon) : image_url('grade_bg.png')
               }

             else
               { percent: nil, icon: image_url('grade_bg.png') }
             end

    instance_variable_set(ivar_name, result)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def next_grade(grade_id)
    next_grade_id = GradeService.next_grade(grade_id)&.id
    next_grade_path = next_grade_id.present? ? grade_path(next_grade_id) : 'javascript:;'

    link_to Spree.t('go_to_the_next_level'),
            next_grade_path,
            class: 'btn white x-small next_level_btn',
            'data-no-turbolink' => true
  end
end
