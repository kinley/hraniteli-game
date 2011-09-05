class Sms < ActiveRecord::Base
  has_one :answer

	def self.new_from_params(params)
		sms = Sms.new
		sms.date = params[:date]
		sms.msg = params[:msg]
		sms.msg_trans = params[:msg_trans]
		sms.operator_id = params[:operator_id]
		sms.country_id = params[:country_id]
		sms.operator = params[:operator]
		sms.user_id = params[:user_id] #номер телефона
		sms.smsid = params[:smsid] 
		sms.num = params[:num]
		sms.cost = params[:cost]
		sms.test = params[:test]
		sms.cost_rur = params[:cost_rur]
		sms.sign = params[:sign]
		sms.save
		return sms
	end

end
