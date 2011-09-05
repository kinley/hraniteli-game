class Question < ActiveRecord::Base
  has_many :answers
  def self.promo
	"0000"
  end
	
	def type=(string)
		@type = string
	end
	
	def type
		@type
	end
  
  def self.promo_used?(string)
	return promo == string
  end

  def self.find_all_opened
    Question.where("open_date < :now", { :now => DateTime.now }).order("pos")
  end
  
  def self.find_with_limit(num)
	Question.limit(num).order("pos")
  end
  
  def self.last_opened
	Question.find_all_opened.last
  end
  
  def self.ready_state(num)
	q = Question.find_by_pos(num)
	q.question = "" unless q.nil?
	return q
  end
  
  def self.find_all_remaining_by_pos(num)
	qs = Question.where("pos > :num", { :num => num }).order("pos")
	qs.each do |q|
		q.question = ""
	end
	return qs
  end
  
  def is_right?(string)
	(answer == string) || Question.promo_used?(string)
  end
	
	def is_opened?
		(open_date < Time.now) && (Time.now < closing_time)
	end
  
  def is_expired?
	closing_time < Time.now
  end
	
	def is_not_expired?
	closing_time > Time.now
  end
  
  def closing_time
		open_date + 20.hours
  end
  
  def elapsed_time
	t = Time.now - open_date
	t > 0 ? t : 0
  end
  
  def remaining_time
	if open_date < Time.now
		closing_time
	else
		open_date
	end
  end
  
  def remaining_time_to_s
		remaining_time.strftime("%Y,%m,%d,%H,%M,%S")
  end
end
