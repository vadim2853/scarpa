module Spree
  module Admin
    class GradesController < Spree::Admin::ResourceController
      before_action :setup_new_quiestion, :setup_new_nomination, only: :edit

      def update_questions_positions
        params[:positions].each { |id, index| Spree::Question.where(id: id).update_all(position: index) }

        respond_to do |format|
          format.html { redirect_to edit_admin_grade_path(@grade) }
          format.js { render text: 'Ok' }
        end
      end

      def update_nominations_positions
        params[:positions].each { |id, index| Spree::Nomination.where(id: id).update_all(position: index) }

        respond_to do |format|
          format.html { redirect_to edit_admin_grade_path(@grade) }
          format.js { render text: 'Ok' }
        end
      end

      private

      def location_after_save
        edit_admin_grade_path(@grade)
      end

      def setup_new_quiestion
        @grade.questions.build if @grade.questions.empty?
      end

      def setup_new_nomination
        @grade.nominations.build if @grade.nominations.empty?
      end
    end
  end
end
