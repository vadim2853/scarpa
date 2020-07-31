class GradeUpdatingInteraction
  def initialize(grade:, score:, data:)
    @grade      = grade
    @score      = score
    @percent    = data[:percent]
    @result_id  = data[:result_id]
    @nomination = data[:nomination] || GradeService.take_nomination(@grade, @score)
    @icon       = @nomination&.icon || ActionController::Base.helpers.asset_path('grade_bg.png')
  end

  def as_json(*)
    {
      score: @score,
      percent: @percent,
      resultId: @result_id,
      nominationName: @nomination && @nomination.title,
      nominationIcon: @icon,
      congratsOrNot: @nomination.present? ? Spree.t('grade.congrats') : Spree.t('grade.fail')
    }
  end
end
