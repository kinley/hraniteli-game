class PostsController < ApplicationController
	before_filter :admin_user, :except => [:index, :show]
	uses_tiny_mce :only => [:new, :create, :edit, :update],
				:options => {
							:theme => 'advanced'
							}
		
	def index
		@posts = Post.all
	end
	
	def show
          begin
		@post = Post.find(params[:id])
                redirect_to :controller => :pages, :action => :nopage if @post.nil?
          rescue
                redirect_to :controller => :pages, :action => :nopage
          end
	end

	def new
		@post = Post.new
	end
	
	def edit
		@post = Post.find(params[:id])
	end
	
	def create
		@post = Post.new(params[:post])
		if @post.save
			flash[:success] = "Post saved"
			redirect_to posts_path
		end
	end
	
	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(params[:post])
			flash[:success] = "Post updated"
			redirect_to posts_path
		end		
	end
	
	def destroy
		Post.find(params[:id]).destroy
		redirect_to posts_path
	end

end
