require 'date'

class NewslettersController < ApplicationController
  before_action :set_newsletter, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /newsletters or /newsletters.json
  def index
    @newsletters = Newsletter.joins("INNER JOIN subscriptions ON subscriptions.newsletters_id = newsletters.id AND subscriptions.users_id = #{current_user.id}")
    @subscribed = Subscription.find_by(users_id: current_user.id, newsletters_id: (params[:id]))
  end

  def discover
    birthday = current_user.birthdate
    @age = ((12*(Date.today.year- birthday.year))-(birthday.month - Date.today.month))/12 
    if @age >= 18 
      @newsletters = Newsletter.all
    else
      @newsletters = Newsletter.all.where(r_rated:false)
    end
  end

  def mine
    @newsletters = Newsletter.all.where(users_id:current_user.id)
  end

  def feed
     @newsletters = Newsletter.joins("INNER JOIN subscriptions ON subscriptions.newsletters_id = newsletters.id AND subscriptions.users_id = #{current_user.id}")
    #  @posts = {{id: 1,
    #  topic: "NEWSLETTER 1",
    #  name: "NEWSLETTER 1",
    #  description: "NEWSLETTER 1",
    #  r_rated: false,
    #  users_id: 2}}
    #  count = 0
     @posts = []
     @newsletters.each do |newsletter|
      newsletter_posts = Post.all.where(newsletters_id: newsletter.id)
      newsletter_posts.each  do |post|
        @posts.push(post)
      end
      @posts.sort_by{ |post| post.created_at }.reverse
     end
  
    # @posts = Post.all.where(newsletters_id:1)
  end

  def posts
    @posts = Post.all.where(newsletters_id: params[:id])
    @newsletter = Newsletter.find_by(id: params[:id])
  end

  # GET /newsletters/1 or /newsletters/1.json
  def show
    @subscribed = Subscription.find_by(users_id: current_user.id, newsletters_id: (params[:id]))
  end

  # GET /newsletters/new
  def new
    @newsletter = Newsletter.new
  end

  # GET /newsletters/1/edit
  def edit
  end

  # POST /newsletters or /newsletters.json
  def create
    @newsletter = Newsletter.new(newsletter_params)
    @newsletter.users_id = current_user.id
    respond_to do |format|
      if @newsletter.save
        format.html { redirect_to newsletter_url(@newsletter), notice: "Newsletter was successfully created." }
        format.json { render :show, status: :created, location: @newsletter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /newsletters/1 or /newsletters/1.json
  def update
    respond_to do |format|
      if @newsletter.update(newsletter_params)
        format.html { redirect_to newsletter_url(@newsletter), notice: "Newsletter was successfully updated." }
        format.json { render :show, status: :ok, location: @newsletter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newsletters/1 or /newsletters/1.json
  def destroy
    @newsletter.destroy

    respond_to do |format|
      format.html { redirect_to newsletters_url, notice: "Newsletter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribe
    respond_to do |format|
      if Subscription.find_or_create_by(users_id: current_user.id, newsletters_id: (params[:id]))
        @newsletter = Newsletter.find_by(id:params[:id])
        format.html { redirect_to newsletter_url(@newsletter), notice: "You have subscribed successfully to this newsletter!" }
        format.json { render :show, status: :ok, location: @newsletter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  def unsubscribe
    subscription = Subscription.find_by(users_id: current_user.id, newsletters_id: (params[:id]))
    respond_to do |format|
        if subscription.destroy
          format.html { redirect_to newsletter_url(params[:newsletter]), notice: "You have unsubscribed succesfully from this newsletter!" }
          format.json { render :show, status: :ok, location: @newsletter }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @newsletter.errors, status: :unprocessable_entity }
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newsletter
      begin
        @newsletter = Newsletter.find(params[:id])
      rescue
        flash[:error] = "Newsletter was deleted or it does not exist"
        redirect_to :action => :index
      end
    end

    # Only allow a list of trusted parameters through.
    def newsletter_params
      params.require(:newsletter).permit(:topic, :name, :description, :users_id, :r_rated, :background)
    end
end
