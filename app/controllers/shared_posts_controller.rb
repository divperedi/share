class SharedPostsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @user = User.find_by(username: params[:username])

    if @user
      @shared_post = @post.shared_posts.build(user: @user)
      if @shared_post.save
        respond_to do |format|
          format.turbo_stream do
            # ✅ Show post in "Shared with Me" for the correct user
            Turbo::StreamsChannel.broadcast_prepend_to(
              view_context.dom_id(@user, :posts_shared),
              target: "posts-shared",
              partial: "posts/post",
              locals: { post: @post, show_share_form: false, show_link: true }
            )

            # ✅ Show post in "I Share" for the post owner
            Turbo::StreamsChannel.broadcast_prepend_to(
              "posts_ishare_#{@post.user.id}",
              target: "posts-ishare",
              partial: "posts/post",
              locals: { post: @post, show_share_form: false, show_link: true }
            )


            render turbo_stream: turbo_stream.prepend(
              view_context.dom_id(@user, :posts_shared),
              partial: "posts/post",
              locals: { post: @post, show_share_form: false, show_link: true }
            )
          end
          format.html { redirect_to @post, notice: "Post was successfully shared." }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post-#{@post.id}-messages", partial: "shared_posts/error", locals: { message: "Unable to share post." }) }
          format.html { redirect_to @post, alert: "Unable to share post." }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post-#{@post.id}-messages", partial: "shared_posts/error", locals: { message: "User not found." }) }
        format.html { redirect_to @post, alert: "User not found." }
      end
    end
  end
end
