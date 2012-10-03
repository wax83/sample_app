class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update] # then if he/she's a correct user to edit/update
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page]) # per_page in the params
  end   

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user 
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    # trying to hit users/x/edit but,
    # signed_in_user then correct_user runs first  
  end

  def update  
    # @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      sign_in @user # sign in to the updated profile
      flash[:success] = "Profile updated" 
      redirect_to @user #  /user/1/
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path # back to the list
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  # private methods for authentication
  private

    def correct_user
      @user = User.find(params[:id])

      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
end
