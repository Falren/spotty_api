# frozen_string_literal: true

class Api::V1::ApiController < ActionController::API
  before_action :authenticate_user!
  respond_to :json

  rescue_from Exception, with: :handle_exception

  protected

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||=
      begin
        user_id = token_decoded["sub"] if token_decoded
        User.find_by(id: user_id) if user_id
      rescue
        nil
      end
  end

  def handle_exception(exception)
    case exception
    when ActionController::ParameterMissing
      render json: { base: { invalid: exception.message } }, status: :bad_request
    when ActiveRecord::RecordInvalid
      respond_with exception.record
    when ActiveRecord::RecordNotFound
      render json: { base: { invalid: "Couldn't find content" } }, status: :not_found
    else
      log_exception(exception)
      render json: { base: { invalid: exception.to_s } }, status: :internal_server_error
    end
  end

  def respond_with(object)
    if object.errors.present?
      errors = {}
      object.errors.details.each do |error, value|
        errors[error] = value.each_with_object do |detail, data|
          next if data[detail[:error]].present?

          data[detail[:error]] = "#{error} #{object.errors.messages[error].shift}"
        end
      end
      return render json: errors, status: :unprocessable_entity
    end

    render json: object.to_json
  end

  private

  def log_exception(exception)
    logger.fatal "API V1 MESSAGE: #{exception.message}"
    logger.fatal "API V1 BACKTRACE: \n\t #{exception.backtrace.grep_v(/\/gems\//).join("\n\t")}"
  end

  def token_decoded
    return unless auth_token.present?

    JWT.decode(auth_token, ENV["JWT_SECRET"]).first
  rescue
    nil
  end

  def auth_token
    @auth_token ||= request.headers["Authorization"]&.split(" ")&.last
  end
end
