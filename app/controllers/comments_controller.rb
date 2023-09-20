class CommentsController < ApplicationController
  skip_before_action :require_login, only: %i[create]

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user ? current_user.id : nil

    if @comment.save
      flash[:success] = t('helpers.flash.comment.success')
      redirect_to spot_path(comment_params[:spot_id])
    else
      flash[:danger] = t('helpers.flash.comment.failure')
      redirect_to spot_path(comment_params[:spot_id])
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
    flash[:success] = t('helpers.flash.comment.destroy')
    redirect_to spot_path(@comment.spot_id)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :spot_id)
  end
end
