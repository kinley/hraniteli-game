class Post < ActiveRecord::Base
	def short_text
		if text.length > 300
			#i = text.index(' ', 300)
			#"#{text.slice(0, i)} <a class='more_link' href='/posts/#{id}'>...</a>
			#	<span id='post_#{id}'>#{text.slice(i, text.length - i)}</span>".html_safe
			return "#{text.slice(0, text.index(' ', 300))} <a class='more_link' href='/posts/#{id}'>...</a>".html_safe
		else
			return text
		end
	end
end
