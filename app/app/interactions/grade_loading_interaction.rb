class GradeLoadingInteraction
  include Rails.application.routes.url_helpers

  # rubocop:disable Metrics/AbcSize
  def initialize(grade_id)
    @grade = Spree::Grade.select(:id, :title, :number).find(grade_id)
    @nomination_minimum = @grade.nominations.unscope(:order).select(:min).order(min: :asc).take.min
    @questions = @grade.questions.select(:id, :title, :description, :variants_type, :variants).map { |q| serialize(q) }

    @literal_name = "#{@grade.number.ordinalize} LEVEL".upcase
    @update_user_score_path = grade_path(@grade.id)
    @clear_grade_session_path = clear_sessions_grades_path
    @certificate_path = certificate_path('_')
    @is_last_grade = Spree::Grade.select(:number).unscope(:order).order(number: :asc).take.number == @grade.number
    @passing_score = Spree::Grade::PASSING_SCORE
  end
  # rubocop:enable Metrics/AbcSize

  private

  def image_path(name)
    ActionController::Base.helpers.image_path(name)
  end

  def serialize(q)
    {
      id: q.id,
      title: q.title,
      description: q.description,
      variantsType: q.variants_type,
      variants: prepare_for_user(q.variants)
    }
  end

  def prepare_for_user(variants)
    variants.each { |h| h.delete('right') }.shuffle
  end
end
