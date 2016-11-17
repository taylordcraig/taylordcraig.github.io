class PostsController < ApplicationController

  before_action :authenticate_user, except: [:index, :show]
  before_action :find_post, only: [:edit, :update, :destroy, :show]
  before_action :authorize_access, only: [:edit, :update, :destroy]
  before_action :set_page, only: [:index]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new find_params
    @post.user = current_user
    if @post.save
      if @post.facebook_post_this
        user_graph = Koala::Facebook::API.new(current_user.oauth_token)
        user_graph.put_wall_post("#{@post.title}: #{@post.body}")
      end
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @post = find_post
    @category = Category.find @post.category_id
    @favourite = @post.favourite_for(current_user)
    respond_to do |format|
      format.html {render}
      format.text {render}
      format.xml {render xml: @post.to_xml}
      format.json {render json: @post.to_json(include: [:category, :comments, :user])}
    end
  end


  def index
    @post = Post.search(params[:search]).order(created_at: :desc).
            includes(:category, :user).page(params[:page]).per(10)
    respond_to do |format|
        format.html {render}
        format.text {render}
        format.xml {render xml: @post.to_xml}
        format.json {render json: @post.to_json(include: [:category, :user])}
    end
  end

  def edit
    @post = find_post
  end

  def update
    @post = find_post
    if @post.update find_params
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = find_post
    @post.destroy
    redirect_to posts_path
  end

  private

  def search
    search_query = params(:query)
    @query = Post.where(['title || body ILIKE ?', "#{search_query}"])
  end

  def set_page
    @page = params[:page] || 0
  end

  def authorize_access
    unless can? :modify, @post
      redirect_to root_path, alert: 'Access denied'
    end
  end

  def find_post
    @post ||= Post.find params[:id]
  end

  def find_params
    params.require(:post).permit([:title, :body, :facebook_post_this, :category_id, tag_ids: []])
  end

  def post_order
    order(created_at: :desc).includes(:category, :user).page(params[:page]).per(10)
  end

end
