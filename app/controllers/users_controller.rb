class UsersController < ApplicationController
  skip_before_filter :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to log_in_url, :notice => "Thank you for signing up.  Please log in below."
    else
      render "new"
    end
  end
end
