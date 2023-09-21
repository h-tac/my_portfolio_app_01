class CommentsController < ApplicationController
  skip_before_action :require_login, only: %i[create]

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user ? current_user.id : nil
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :spot_id)
  end
end
