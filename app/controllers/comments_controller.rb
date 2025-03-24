class CommentsController < ApplicationController
  before_action :require_authentication
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = "Comment was successfully created."
        format.html { redirect_to @post, notice: "Comment was successfully created." }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append("comments_#{@post.id}", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.append("flash_notifications", partial: "shared/comment_flash", locals: { flash: flash }),
            turbo_stream.update("new_comment_form", partial: "comments/new", locals: { post: @post })
          ]
        }
      else
        flash.now[:alert] = "Failed to create comment."
        format.html { redirect_to @post, alert: "Failed to create comment." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.append("flash_notifications", partial: "shared/comment_flash", locals: { flash: flash })
        }
      end
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
