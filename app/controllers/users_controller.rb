class UsersController < ApplicationController

	include VerifyPhoneNumberHelper

	def index
		@users = User.all
	end

	def show
    @user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def edit
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(user_params)

		if @user.save!
		  redirect_to @user
		else
		  render 'new'
		end
	end

	def send_code_again
    @user = User.find(params[:id])
		@user.generate_new_code_and_send_sms
		redirect_to @user
	end

	def verify_phone_number
    @user = User.find(params[:id])
		code_entered = params['myform']['code_entered']
		# puts "from controller"
		# puts code_entered
		@user.verify_phone_verification_code_with_code_entered(code_entered)
		redirect_to @user
	end

	def update
		@user = User.find(params[:id])

		if @user.update(user_params)
		  redirect_to @user
		end
	end

	def destroy
		@user = User.find(params[:id])
	  if @user.destroy!
			redirect_to users_path
		else
			redirect_to @user
		end
	end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    # def set_user
	    #   @user = User.find(params[:id])
	    # end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def user_params
	      params.require(:user).permit(:name, :phone_number)
	    end
end
