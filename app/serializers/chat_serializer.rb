class ChatSerializer < ApplicationSerializer
  attributes :id, :other_user

  def other_user
    (object.users - [ scope ]).first
  end
end
