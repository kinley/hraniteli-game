class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(user)
  	@user = user
  	@url = "runkzn.ru/signin"
  	mail(:to => user.email,
  				:subject => "Welcome to our project!")
  end
  
end
