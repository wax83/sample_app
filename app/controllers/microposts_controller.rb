class MicropostsController < ApplicationController
  before_filter :signed_in_user 
  before_filter :correct_user, only: :destroy 

  def create
    @micropost = current_user.microposts.build(params[:micropost])

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end                      
  end

  def destroy
    @micropost.destroy # see correct_user below
    redirect_to root_path
  end

  private

    def correct_user 
      @micropost = current_user.microposts.find_by_id(params[:id])
      # find the right micropost to delete
      redirect_to root_path if @micropost.nil?
    end

end
