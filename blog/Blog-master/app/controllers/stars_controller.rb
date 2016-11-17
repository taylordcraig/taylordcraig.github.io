class StarsController < ApplicationController
  before_action :authenticate_user

  def create
    star = Star.new star_params
    post = Post.find params[:post_id]
    star.user = current_user
    star.post = post
    if star.save
      redirect_to post_path(post)
    else
      redirect_to post_path(post), alert: star.error_message
    end
  end

  def destroy
    post = star.post
    star.destroy
    redirect_to post_path(post)
  end

  def update
    post = star.post
    if star.update star_params
      redirect_to post_path(post)
    else
      redirect_to post_path(post), alert: star.error_message
    end
  end

  private

  def star_params
    params.require(:star).permit(:star_count)
  end

  def post
    post ||= Post.find_by id: params[:id]
  end

  def star
    star ||= Star.find_by id: params[:id]
  end

end
