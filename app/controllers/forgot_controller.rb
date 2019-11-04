class ForgotController < ApplicationController
  def new
  end

  def password_reset
    #check unlogin user
    @muser = MUser.find_by(email: params[:forgot_password][:email].downcase)
    if @muser
      @muser_email= MUser.new
      @muser_email.email = params[:forgot_password][:email]
      UserMailer.reset_password(@muser_email).deliver_now
    flash[:info] = "Check Your Email"
    redirect_to welcome_url
    end
  end
  def resetPassword
    checkloginuser
    @m_user = MUser.new
    @m_user.email = params[:email]
  end

  def edit
    @m_user = MUser.new
    password = params[:m_user][:password]
    password_confirmation = params[:m_user][:password_confirmation]
    @m_user.email = params[:email]
    if password == "" || password.nil?
      flash[:danger] = "Password can't be blank."
      redirect_to forgot_password_url(id: session[:user_id])
    elsif password_confirmation == "" || password_confirmation.nil?
      flash[:danger] = "Confirm Password can't be blank."
      redirect_to forgot_password_url(id: session[:user_id])
    elsif password != password_confirmation
      flash[:danger] = "Password and Confirmation Password does not match."
      redirect_to forgot_password_url(id: session[:user_id])
    else 
     @m_user.update_attributes(user_params)
     MUser.where(email: @m_user.email).update_all(password_digest: @m_user.password_digest)
     flash[:success] = "Reset Password Successful."
      redirect_to welcome_url
    end
  end
  private
  def user_params
    params.require(:m_user).permit(:password, :password_confirmation)
  end
end
