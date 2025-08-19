class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.prototype_id = params[:prototype_id]
    
    if @comment.save
      redirect_to prototype_path(@comment.prototype), notice: 'コメントが正常に投稿されました'
    else
      @prototype = Prototype.find(params[:prototype_id])
      @comments = @prototype.comments
      render "prototypes/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
