class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	validates :name, presence: true
	validates :phone_number, presence: true, uniqueness: true

	include VerifyPhoneNumberHelper

  before_save :set_phone_attributes, if: :phone_verification_needed?
  after_save :send_sms_for_phone_verification, if: :phone_verification_needed?

	def verify_phone_verification_code_with_code_entered(code_entered)
		if self.phone_verification_code == code_entered
			mark_phone_as_verified!
		end
	end

  def generate_new_code_and_send_sms
  	self.phone_verified = false
		if self.save!
    	send_sms_for_phone_verification
    end
  end

  private

	  def mark_phone_as_verified!
	  	update!(phone_verified: true, phone_verification_code: nil)
	  end	

	  def set_phone_attributes
	    self.phone_verified = false
	    self.phone_verification_code = generate_phone_verification_code

	    # removes all white spaces, hyphens, and parenthesis
	    self.phone_number.gsub!(/[\s\-\(\)]+/, '')
	  end

	  def send_sms_for_phone_verification
	    send_verification_code_to(self)
	  end

	  def generate_phone_verification_code
	    # begin
	    verification_code = SecureRandom.hex(3)
	    # end while self.class.exists?(phone_verification_code: verification_code)

	    verification_code
	  end

	  def phone_verification_needed?
	    phone_number.present? && !phone_verified
	  end

end
