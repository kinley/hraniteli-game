class PagesController < ApplicationController
	#add_crumb("Новости", :only => "") { |instance| instance.send :posts_path }
  #before_filter :correct_user, :only => [:personal]
  before_filter :admin_user, :only => :feedback
  before_filter :secure_request, :only => :processing
  #layout nil, :only => [:processing]
  uses_tiny_mce :only => [:new, :create, :edit, :update],
				:options => {
							:theme => 'advanced'
							}
	
  def home
	@posts = Post.all
	@title = "Новости"
  end
  
  def processing
		@sms = Sms.new_from_params(params)
		text = Answer.generate_from_sms(@sms)
		render :inline => text
	
	#@question = @answer.question
	#@answer = Answer.last	
  	#@sms_id = Sms.new_from_params(params).save.id
	#@sms_id = @sms.id
    #@user = User.find_by_phone(params[:user_id])
    #@question = Question.last
    #Answer.new(:user_id => @user.nil? ? nil : @user.id, :sms_id => @sms_id, :question_id => @question.id, :text => params[:msg], :is_right => false).save
  	#render :inline => "smsid:" + params[:smsid] + "\nstatus: reply\n\nVas privetstvuet RunKZN! otvet prinyat " + params[:msg_trans]
  end
	
	def notfound
		flash[:error] = 'Page not found!'
  end
	
	def index
		@pages = Page.all
	end
	
	def show
		@href = params[:href]
		@page = Page.find_by_href(@href)
		@title = @page.title
    #if @page.nil?
    #	redirect_to :action => 'notfound'
    #end
	end

	def new
		@page = Page.new
	end
	
	def edit
		@page = Page.find(params[:id])
	end
	
	def create
		@page = Page.new(params[:page])
		if @page.save
			flash[:success] = "Page saved!"
			redirect_to root_path
		else
			render 'new'
		end
	end
	
	def update
		@page = Page.find(params[:id])
		if @page.update_attributes(params[:page])
			flash[:success] = "Page updated!"
			redirect_to pages_path
		else
			render 'edit'
		end
	end
	
	def destroy
		Page.find(params[:id]).destroy
		redirect_to pages_path
	end	
	
	private
	
	def response_processing(sms, answer)
		"smsid: #{ sms.smsid }\nstatus: reply\n\nVas privetstvuyut hraniteli!\nVopros ##{ answer.question.pos }\nVash otvet: #{ sms.msg_trans }\n" + (answer.is_right? ? "Otvet verniy" : "Otvet neverniy")
	end
	
	def response_processing_no_user(sms)
		"smsid: #{ sms.smsid }\nstatus: reply\n\nVas privetstvuyut hraniteli!\nPolzovatel s takim nomerom ne zaregistrirovan"
	end
	
	def response_processing_not_opened(sms)
		"smsid: #{ sms.smsid }\nstatus: reply\n\nVas privetstvuyut hraniteli!\nVopros ewe zakrit"
	end
	
	def response_processing_promo_used(sms)
		"smsid: #{ sms.smsid }\nstatus: reply\n\nVas privetstvuyut hraniteli!\nVi ispolzovali promo kod. Vash otvet prinyat"
	end
	
	def secure_request
		ips = ["79.137.235.129", "78.108.178.206", "88.214.194.119"]
		render :inline => "систему не обманешь!" unless ips.include?(request.remote_ip)
		render :inline => "систему не обманешь!" unless params[:skey] == Digest::MD5.hexdigest("t3Rdgt")
	end
	
end
