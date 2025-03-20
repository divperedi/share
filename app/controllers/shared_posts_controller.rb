class SharedPostsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @user = User.find_by(username: params[:username])

    if @user
      @shared_post = @post.shared_posts.build(user: @user)

      if @shared_post.save
        respond_to do |format|
          format.turbo_stream do
            Turbo::StreamsChannel.broadcast_prepend_to(
              view_context.dom_id(@user, :posts_shared),
              target: "posts-shared",
              partial: "posts/post",
              locals: { post: @post, show_share_form: false, show_link: true }
            )

            Turbo::StreamsChannel.broadcast_prepend_to(
              "posts_ishare_#{@post.user.id}",
              target: "posts-ishare",
              partial: "posts/post",
              locals: { post: @post, show_share_form: false, show_link: true }
            )

            render turbo_stream: turbo_stream.replace(
              view_context.dom_id(@post, :share_error),
              partial: "shared/success",
              locals: { message: "Post was successfully shared." }
            )
          end
          format.html { redirect_to @post, notice: "Post was successfully shared." }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              view_context.dom_id(@post, :share_error),
              partial: "shared/error",
              locals: { message: "Unable to share post." }
            )
          end
          format.html { redirect_to @post, alert: "Unable to share post." }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            view_context.dom_id(@post, :share_error),
            partial: "shared/error",
            locals: { message: "User not found." }
          )
        end
        format.html { redirect_to @post, alert: "User not found." }
      end
    end
  end
end
