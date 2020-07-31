class GradesController < StoreController
  before_action :ensure_access_to_grade, only: :show

  def index
    @grades = Spree::Grade.all.unscope(:order).order(number: :desc)
  end

  def show
    @props = GradeLoadingInteraction.new(params[:id]).to_json
  end

  def update
    save_session_result(Spree::Question.right_answer?(params))

    if params[:finalize]
      score = session[:grade_score]
      grade = Spree::Grade.find(params[:id])
      data  = if spree_current_user.present?
                finalize_grade(spree_current_user.id, grade)
              else
                session[:grade_percent] = GradeService.calculate_percent(grade, score)
                session[:show_certificate] = true
                { percent: session[:grade_percent] }
              end

      render json: GradeUpdatingInteraction.new(grade: grade, score: score, data: data)
    else
      render nothing: true
    end
  end

  def clear_sessions
    session[:grade_score]   = nil
    session[:grade_percent] = nil

    render nothing: true
  end

  private

  def save_session_result(right_answer)
    session[:grade_score]  = 0 if session[:grade_score].blank?
    session[:grade_score] += 1 if right_answer
  end

  def ensure_access_to_grade
    first_grade_id    = Spree::Grade.first.id
    selected_grade_id = params[:id].to_i

    if (spree_current_user.present? &&
       !spree_current_user.access_to_grade?(selected_grade_id, first_grade_id)) ||
       (spree_current_user.blank? && selected_grade_id != first_grade_id)

      redirect_to grades_path
    end
  end
end
