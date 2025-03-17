class CommentsController < ApplicationController
  before_action :require_authentication
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    Rails.logger.debug("Current User: #{current_user.inspect}")
    Rails.logger.debug("Post: #{@post.inspect}")
    Rails.logger.debug("Comment: #{@comment.inspect}")

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
      turbo_stream
    else
      redirect_to @post, alert: "Failed to create comment."
      turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
