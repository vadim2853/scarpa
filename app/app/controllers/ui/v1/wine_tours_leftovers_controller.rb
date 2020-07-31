class Ui::V1::WineToursLeftoversController < Ui::BaseController
  def show
    respond_with_interaction Ui::LeftoverLoadingInteraction
  end
end
