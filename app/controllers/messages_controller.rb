class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      ActionCable.server.broadcast(
        "chatroom_#{@message.chatroom_id}",
        type: :create, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
      )
      head :ok
    else
      head :bad_request
    end
  end

  def edit
    @message = current_user.messages.find(params[:id])
  end

  def update
    @message = current_user.messages.find(params[:id])
    if @message.update(message_update_params)
      ActionCable.server.broadcast(
        "chatroom_#{@message.chatroom_id}",
        type: :update, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
      )
      head :ok
    else
      head :bad_request
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy!

    ActionCable.server.broadcast(
      "chatroom_#{@message.chatroom_id}",
      type: :delete, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
    )
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(chatroom_id: params[:chatroom_id])
  end

  def message_update_params
    params.require(:message).permit(:body)
  end
end
