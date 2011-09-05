class UsersController < ApplicationController
  #before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:show, :edit, :update]
  before_filter :admin_user, :only => [:destroy, :edit, :index]

  def index
  	# @users = User.all
  	@users = User.paginate(:page => params[:page], :order => params[:sort_by], :per_page => 30)
		@questions = Question.find_all_opened
  end
	
	def messages
		@messages = Message.where("user_id is null OR user_id = ?", current_user.id)
	end
	
	def view
		@user = User.find(params[:id])
	end
 
  def new
  	@user = User.new
  end
  
  def show
  	@user = User.find(params[:id])
		@title = "Личный кабинет"
  	if signed_in?
			@questions = current_user.generate_questions_list
  	  #@questions = Question.find_all_opened
      #@questions_count = Question.count
      #@next_question = @user.next_question #TODO: зачем и где используется эта переменная???
  	end
  end
  
  def create
  	@user = User.new(params[:user])
	if verify_recaptcha(request.remote_ip, params)[:status] == 'true'
	  #@user.errors.add(:recaptha, "captcha incorrect")
	  #@user.errors[:recaptha] << ("captcha incorrect")
	  @notice = "captcha incorrect"
	  render 'new'
	elsif @user.save
  	  UserMailer.welcome_email(@user).deliver
	  @user.create_user_info(:last_answered => 0, :total_answer_time => 0)
  	  sign_in @user
  	  flash[:success] = "Welcome to our site!"
  	  redirect_to @user
  	else
  	  render 'new'
  	end
  end
  
  def edit
  	@user = User.find(params[:id]) # можно убрать, т.к. предфильтр correct_user определяет @user
  end
  
  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(params[:user])
  	  flash[:success] = "Profile updated"
  	  redirect_to @user
  	else
  	  render 'edit'
  	end
  end
  
  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User destroyed"
  	redirect_to users_path
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end    

end
