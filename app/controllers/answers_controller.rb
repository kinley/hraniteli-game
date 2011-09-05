class AnswersController < ApplicationController
	#before_filter :admin_user, :except => [:index, :show]
	
	def index
		@answers = Answer.all
	end
	
	def new
		@answer = Answer.new
	end
	
	def edit
		@answer = Answer.find(params[:id])
	end
	
	def create
		@answer = Answer.new(params[:answer])
		if @answer.save
			redirect_to answers_path
		end
	end
	
	def update
		@answer = Answer.find(params[:id])
		if @answer.update_attributes(params[:answer])
			flash[:success] = "Answer updated"
			redirect_to answers_path
		end		
	end
	
	def destroy
		Answer.find(params[:id]).destroy
		redirect_to answers_path
	end
	
end
