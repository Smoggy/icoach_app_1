class UsersController < ApplicationController
	
	respond_to :json


	def index
		render :json=> {:success=>true, :message=>"you finally did it"}
	end

	def create
		@user = User.create_user(params)

		if @user.valid?
			@user.save
			sign_in(@user)
			session[:token] = @user.token
		else
			render :json=> {:status => 1, :messages => @user.errors.messages }
		end
	end

end