class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[ show edit update destroy share ]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    @posts_my = current_user.posts
    @posts_shared = current_user.shared_posts_received
    @posts_ishare = Post.joins(:shared_posts).where(user_id: current_user.id).distinct
  end

  def show
    @comments = @post.comments.includes(:user)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        flash.now[:notice] = "Post was successfully created"

        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append("posts_my", partial: "posts/post", locals: { post: @post, show_share_form: true, show_link: true }),
            turbo_stream.append("flash_notifications", partial: "shared/flash", locals: { flash: flash })
          ]
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        flash.now[:notice] = "Post was successfully updated."

        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@post, partial: "posts/post", locals: { post: @post, show_share_form: true, show_link: true }),
            turbo_stream.append("flash_notifications", partial: "shared/flash", locals: { flash: flash })
          ]
        }
        format.html { redirect_to @post, notice: "Post was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      flash.now[:notice] = "Post and its comments were successfully destroyed"

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@post),
          turbo_stream.remove("comments_#{@post.id}"),
          turbo_stream.append("flash_notifications", partial: "shared/flash", locals: { flash: flash })
        ]
      end
    end
  end

  def share
    @user = User.find_by(username: params[:username])

    if @user
      @shared_post = @post.shared_posts.build(user: @user)
      if @shared_post.save
        flash.now[:notice] = "Post was successfully shared"

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.prepend("#{dom_id(@user, :posts_shared)}_posts", partial: "posts/post", locals: { post: @post, show_share_form: false, show_link: true }),
              turbo_stream.prepend("posts-ishare", partial: "posts/post", locals: { post: @post, show_share_form: false, show_link: true }),
              turbo_stream.append("flash_notifications", partial: "shared/flash", locals: { flash: flash })
            ]
          end
          format.html { redirect_to @post, notice: "Post was successfully shared" }
        end
      else
        respond_to do |format|
          format.html { redirect_to @post, alert: "Unable to share post" }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post-#{@post.id}-messages", partial: "shared_posts/error", locals: { message: "Unable to share post." }) }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "User not found" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post-#{@post.id}-messages", partial: "shared_posts/error", locals: { message: "User not found." }) }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def handle_record_not_found
    flash.now[:alert] = "The post you are looking for does not exist."

    @posts_my = current_user.posts
    @posts_shared = current_user.shared_posts_received
    @posts_ishare = Post.joins(:shared_posts).where(user_id: current_user.id).distinct

    render :index, status: :not_found
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
