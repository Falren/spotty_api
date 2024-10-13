class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel:#{params[:chat_id]}"
  end

  def unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast("chat_channel:#{params[:chat_id]}", { body: data["message"], type: "message" })
  end
end
