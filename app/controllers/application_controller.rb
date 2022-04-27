class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request, :ensure_user_below_rate_limit
  attr_reader :current_user

  private

  READ_METHODS = ['GET']
  WRITE_METHODS = %w[PUT POST DELETE]

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  def ensure_user_below_rate_limit
    raise(ExceptionHandler::OverRateLimit, Message.over_rate_limit) if @current_user.over_rapid_request_limit?

    raise(ExceptionHandler::OverRateLimit, Message.over_rate_limit) if @current_user.over_read_request_limit?

    raise(ExceptionHandler::OverRateLimit, Message.over_rate_limit) if @current_user.over_write_request_limit?

    action = READ_METHODS.include?(request.method) ? 1 : 2

    @current_user.user_requests.create(action: action)
  end
end
