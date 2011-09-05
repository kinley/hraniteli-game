require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :surname, :name, :middlename, :birthday, :email, :password, :password_confirmation, :phone
    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  phone_regex = /\A[\d]{11}\Z/

  validates :name,  :presence => true, 
                    :length   => { :maximum => 50 }
	validates :surname,  :presence => true, 
                    :length   => { :maximum => 50 }
	validates :middlename,  :presence => true, 
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
	validates :phone, :presence => true,
										:format		=> { :with => phone_regex },
										:uniqueness => true
										
  has_many :answers
  has_one :user_info

  before_save :encrypt_password
	
	def full_name
		[surname, name, middlename].join(" ")
	end
  
  def has_password?(submitted_password)
  	encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)
  	return nil if user.nil?
  	return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
  	user = find_by_id(id)
  	(user && user.salt == cookie_salt) ? user : nil
  end
	
	def generate_questions_list
		questions = []
		promoted_question_id = Answer.promo_used_question_id(id)
		answered_questions.each do |question|
			question.type = (promoted_question_id == question.id)? "promoted" : "answered" 
			questions << question
		end
		questions << current_question unless current_question.nil?
		remaining_questions.each do |question|
			question.type = "closed"
			question.question = ""
			questions << question
		end
		return questions
	end
  
  def answered_questions
	return Question.find_with_limit(user_info.last_answered)
  end
  
  def current_question
		if last_opened_is_not_answered?
			q = Question.find_by_pos(user_info.last_answered + 1)
			if q.nil?
				return nil
			end
			if q.is_not_expired?
				q.type = "current"
			else
				q.type = "wrong"
			end
		else
			q = Question.ready_state(user_info.last_answered + 1)
			if q.nil?
				return nil
			end
			q.type = "ready"
		end
		return q
  end
	
	def remaining_questions
		q = current_question
		if q.type == "wrong" || q.nil?
			return []
		else
			Question.where("pos > :num", { :num => q.pos }).order("pos")
		end
	end
	
	def last_opened_is_not_expired?
	Question.find_by_pos(user_info.last_answered + 1).open_date + 22.hours > Time.now
  end
  
  def last_opened_is_expired?
	Question.find_by_pos(user_info.last_answered + 1).open_date + 22.hours < Time.now
  end
  
  def last_opened_is_not_answered?
	if Question.last_opened.nil?
		return false
	else
		(user_info.last_answered < Question.last_opened.pos)
	end
  end
	
	#менаундхлнярэ онякедсчыху лернднб онд бнопнянл
  
  def next_question
	question = Question.find_by_pos(Question.find_all_opened.count + 1)
	unless question.nil?
		question.question = nil 
	end
	return question
  end  
	  
  #def remaining_questions
	#return current_question.nil? ? nil : Question.find_all_remaining_by_pos(current_question.pos)
  #end
  
  def remaining_questions_num
	return Question.last.pos - current_question.pos
  end
  
  def self.answered_to_question(num)
		return UserInfo.where("last_answered >= :num", { :num => num }).order("user_id").count
  end
  
  def promo_not_used?
		return answers.where(:promo_used => true).empty?
  end
	
	#бнр дн нрячднбю

  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
