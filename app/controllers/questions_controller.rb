class QuestionsController < ApplicationController
	before_filter :admin_user, :except => [:index, :show]
	
	def index
		@questions = Question.all
	end
	
	def new
		@question = Question.new
	end
	
	def edit
		@question = Question.find(params[:id])
	end
	
	def create
		@question = Question.new(params[:question])
		@question.answer = @question.answer.strip
		if @question.save
			redirect_to questions_path
		end
	end
	
	def update
		@question = Question.find(params[:id])
		if @question.update_attributes(params[:question])
			@question.answer = @question.answer.strip
			@question.save
			flash[:success] = "Question updated"
			redirect_to questions_path
		end		
	end
	
	def destroy
		Question.find(params[:id]).destroy
		redirect_to questions_path
	end
	
end
