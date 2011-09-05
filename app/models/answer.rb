class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :sms
  
  def answer_time_to_s
		created_at.strftime("%d.%m.%y %H:%M:%S")
  end
  
  def self.generate_from_sms(sms)
		user = User.find_by_phone(sms.user_id)
		promo_not_used_yet = user.promo_not_used?
		@answer = nil
		unless user.nil?
			@answer = Answer.generate(sms, user)
		end
		return Answer.generate_response_text(sms, @answer, promo_not_used_yet)
  end
  
  def self.generate(sms, user)
	question = user.current_question
	promo_not_reused = !(!user.promo_not_used? && Question.promo_used?(sms.msg))
	answer = Answer.new(:user_id => user.nil? ? nil : user.id, :sms_id => sms.id, 
		:question_id => question.id, :text => sms.msg, :is_right => (question.is_right?(sms.msg) && question.is_opened? && promo_not_reused), 
		:promo_used => (Question.promo_used?(sms.msg)))
	if question.is_opened? 
		answer.save
	end
	if answer.is_right?
		# user.user_info.update_answer_results(question.elapsed_time)
		user.user_info.last_answered += 1
		user.user_info.total_answer_time += question.elapsed_time
		#t = Time.new
		#t = Time.at(user.user_info.total_answer_time)
		#t += question.elapsed_time
		#user.user_info.total_answer_time = t
		user.user_info.save
	end
	return answer
  end
  
	def self.promo_used_question_id(user_id)
		answer = Answer.where({:user_id => user_id, :promo_used => true}).first.
		answer.question_id if answer
	end
		
	def self.generate_response_text(sms, answer, promo_not_used_yet)
		s = "smsid: #{ sms.smsid }\nstatus: reply\n\nVas privetstvuyut hraniteli!\n"
		if answer.nil?
			s += "Polzovatel s takim nomerom ne zaregistrirovan"
		elsif !@answer.question.is_opened?
			s += "Vopros ewe zakrit"
		elsif @answer.promo_used? && promo_not_used_yet
			s += "Vi ispolzovali promo kod. Vash otvet prinyat"
		elsif @answer.promo_used?
			s += "Vi uzhe polzovalis promo kodom!"
		else
			s += "Vopros ##{ answer.question.pos }\nVash otvet: #{ sms.msg_trans }\n" + (answer.is_right? ? "Otvet verniy" : "Otvet neverniy")
		end
		return s
	end
	
end
