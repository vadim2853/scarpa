class InvoicesController < ApplicationController
  respond_to :pdf

  def show
    @order = Spree::Order.find_by!(number: params[:id])
  end
end
