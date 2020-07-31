class GradeService
  class << self
    def finalize(user_id, grade, score)
      percent    = calculate_percent(grade, score)
      result     = Spree::GradesResult.find_or_initialize_by(user_id: user_id, grade_id: grade.id)
      nomination = take_nomination(grade, score)

      result.nomination_id = nomination&.id
      result.percent = percent
      result.score = score
      result.save
      { result_id: result.id, percent: percent, nomination: nomination }
    end

    def calculate_percent(grade, score)
      score > 0 ? (score * 100 / grade.questions.count).round : 0
    end

    def take_nomination(grade, score)
      grade
        .nominations
        .unscope(:order)
        .where(min: 0..score)
        .order(min: :desc)
        .take
    end

    def next_grade(grade_id)
      Spree::Grade.select(:id)
                  .where('number < ?', Spree::Grade.select(:number).find(grade_id).number)
                  .unscope(:order)
                  .order(number: :desc)
                  .take
    end
  end
end
