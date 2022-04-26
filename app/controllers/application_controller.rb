class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_request, :track_request
  attr_reader :current_user

  private

  # @@requests = {}

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  def track_request
    # return if !@current_user
    # current_time = DateTime.now

    # if @@requests.key?(@current_user)
    #   if (@@requests[@current_user]) > 3 && (current_time > @@requests[@current_user].time_of_first_request + 1.second)
    #     p 'Would add logging information'
    #     # would block actual request
    #     return
    #   end

    #   @@requests[@current_user] += { time_of_first_request: current_time,
    #                                  number_of_requests: @@requests[@current_user].number_of_requests + 1 }
    # else
    #   @@requests[@current_user] = { time_of_first_request: current_time, number_of_requests: 1 }
    # end
  end
end
