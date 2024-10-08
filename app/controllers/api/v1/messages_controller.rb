# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApiController
      def index
        @chat = current_user.chats.find_by(id: params[:chat_id])
        render json: @chat.messages.order(id: :desc), status: :ok
      end

      def create
        @message = current_user.messages.build(messages_params)
        status :ok
      end

      private

      def messages_params
        params.require(:message).permit(:body, :chat_id)
      end
    end
  end
end
