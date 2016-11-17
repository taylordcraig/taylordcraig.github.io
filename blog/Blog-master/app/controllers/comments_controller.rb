class CommentsController < ApplicationController
  before_action :authenticate_user

  def create
    comment_params = params.require(:comment).permit([:body])
    @comment = Comment.new comment_params
    @post = find_post
    @comment.user = current_user
    @comment.post = @post
    respond_to do |format|
      if @comment.save
        format.js { render :create_comment_success }
        format.html { redirect_to post_path(@post), notice: 'Comment created' }
      else
        format.js { render :create_comment_failure }
        format.html { redirect_to post_path(@post) }
      end
    end
  end

  def destroy
    post = find_post
    @comment = Comment.find params[:id]
    respond_to do |format|
      if can? :delete, @comment
        @comment.destroy
        format.js {render}
        format.html { redirect_to post, notice: 'Comment deleted!'}
      else
        format.js {render js: 'alert:("Access denied");' }
        format.html { redirect_to post_path, alert: 'Access Denied' }
      end
    end
  end

  private

  def find_post
    Post.find params[:post_id]
  end
end
