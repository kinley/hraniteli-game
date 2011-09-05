class SessionsController < ApplicationController
  
  def new
  end
  
  def create
  	user = User.authenticate(params[:session][:email], params[:session][:password])
  	
  	if user.nil?
  	  flash[:error] = "Неправильно введён e-mail или пароль"
  	  redirect_to root_path
  	else
  	  sign_in user
  	  #redirect_back_or root_path
  	  redirect_to user
  	end
  end
  
  def destroy
  	sign_out
  	redirect_to root_path
  end

end
