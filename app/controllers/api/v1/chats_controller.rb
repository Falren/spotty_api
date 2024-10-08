# frozen_string_literal: true

module Api
  module V1
    class ChatsController < ApiController
      def show
        @chat = Chat.find_by(id: params[:id])
        render json: @chat, serializer: ChatSerializer, scope: current_user
      end
    end
  end
end
