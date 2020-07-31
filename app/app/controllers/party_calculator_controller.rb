class PartyCalculatorController < StoreController
  def index
    @props = CalculatorLoadingInteraction.new.as_json
  end
end
