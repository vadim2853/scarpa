module Spree
  module Admin
    class QuizzesController < Spree::Admin::ResourceController
      before_action :setup_new_grade, only: :edit

      def update_grades_positions
        params[:positions].each { |id, index| Spree::Grade.where(id: id).update_all(position: index) }

        respond_to do |format|
          format.html { redirect_to edit_admin_quiz_path(@quiz) }
          format.js { render text: 'Ok' }
        end
      end

      private

      def location_after_save
        edit_admin_quiz_path(@quiz)
      end

      def setup_new_grade
        @quiz.grades.build if @quiz.grades.empty?
      end
    end
  end
end
