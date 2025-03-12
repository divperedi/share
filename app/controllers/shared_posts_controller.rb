class SharedPostsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @user = User.find_by(username: params[:username])

    if @user
      @shared_post = @post.shared_posts.build(user: @user)
      if @shared_post.save
        redirect_to @post, notice: "Post was successfully shared."
      else
        redirect_to @post, alert: "Unable to share post."
      end
    else
      redirect_to @post, alert: "User not found."
    end
  end
end
