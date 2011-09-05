class FeedbacksController < ApplicationController
  before_filter :admin_user, :only => :index

  def index
    @feedbacks = Feedback.all
  end

  def new
	@title = "Обратная связь"
    @feedback = current_user.nil? ? Feedback.new : Feedback.new(:email => current_user[:email], :from => current_user[:name])
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.save
      flash[:success] = "Спасибо за обратную связь!"
      redirect_to root_path
    end
  end
  
  def destroy
		Feedback.find(params[:id]).destroy
		redirect_to feedbacks_path
	end

end
