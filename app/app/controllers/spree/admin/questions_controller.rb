module Spree
  module Admin
    class QuestionsController < Spree::Admin::ResourceController
      before_action :process_params, only: :update

      private

      def location_after_save
        edit_admin_question_path(@question)
      end

      def process_params
        question = params.require(:question)
        question[:variants] = question[:variants].present? ? question[:variants].values : []
      end
    end
  end
end
