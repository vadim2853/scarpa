class BaseInteraction
  attr_accessor :user, :params, :options

  def initialize(user:, params:, options:)
    @user = user
    @params = params
    @options = options

    init
  end

  def init
  end
end
