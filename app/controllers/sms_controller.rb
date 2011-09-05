class SmsController < ApplicationController

	def index
		@sms = Sms.all
	end
end
