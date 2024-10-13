# require "jwt"

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
    end

    private

    def find_user
      # ToDo
      #
      # token = request.params["token"]
      # token = token.split(" ").last if token
      # begin
      #   decoded = JWT.decode(token, ENV["JWT_SECRET"]).first
      #   user_id = decoded["sub"]
      #   User.find(user_id)
      # rescue ActiveRecord::RecordNotFound => e
      #   Rails.logger.error e
      #   reject_unauthorized_connection
      # rescue JWT::DecodeError => e
      #   Rails.logger.error e
      #   reject_unauthorized_connection
      # end
    end
  end
end
