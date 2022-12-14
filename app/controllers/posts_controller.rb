class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end
  def show_profile
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
    @post = Post.new(post_params)
    @post.users_id = current_user.id
    respond_to do |format|
      if @post.save
        @author = User.find_by(id:@post.users_id)
        PostMailer.with(author: @author, post:@post).post_created.deliver_now
        format.html { redirect_to newsletter_posts_path(Newsletter.find_by(id:@post.newsletters_id)), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
        
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to newsletter_posts_path(Newsletter.find_by(id:@post.newsletters_id)), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to newsletter_posts_path(Newsletter.find_by(id:@post.newsletters_id)), notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      begin
        @post = Post.find(params[:id])
      rescue
        flash[:error] = "User not found"
        redirect_to :action => :index
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :description, :newsletters_id, :users_id, :image)
    end
end
