class CertificatesController < ApplicationController
  layout 'crawler'

  def show
    @result = Spree::GradesResult.find(params[:id])

    respond_to do |format|
      format.html do
        @grade = @result.grade
        @data  = { percent: @result.percent, icon: @result&.nomination&.icon(:large) }

        render :share
      end

      format.pdf { render :show }
    end
  end
end
