module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  class OverRateLimit < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::AuthenticationError do |e|
      json_response({ message: e.message }, :unauthorized)
    end

    rescue_from ExceptionHandler::MissingToken do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::InvalidToken do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ExceptionHandler::OverRateLimit do |e|
      json_response({ message: e.message }, :too_many_requests)
    end
  end
end
