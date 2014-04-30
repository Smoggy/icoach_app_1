class UsersController < ApplicationController
	respond_to :json


	def index
		render :json=> {:success=>true, :message=>"you finally did it"}
	end



end