class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts_my = current_user.posts
    @posts_shared = current_user.shared_posts_received
    @posts_ishare = Post.joins(:shared_posts).where(user_id: current_user.id).distinct
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("posts_my", partial: "posts/post", locals: { post: @post, show_share_form: true, show_link: true }) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@post) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
