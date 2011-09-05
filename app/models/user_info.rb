class UserInfo < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  
  def total_answer_time_to_s
	 Time.at(total_answer_time).utc.strftime("%H:%M:%S")
  end
  
  #def update_answer_results(elapsed_time)
	#user_info.last_answered += 1
	#t = Time.new
	#t = total_answer_time
	#t += elapsed_time
	#total_answer_time = t
	#this.save
  #end
end
