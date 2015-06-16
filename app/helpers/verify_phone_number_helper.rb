module VerifyPhoneNumberHelper

  def send_verification_code_to(user)
    number_to_send_to = user.phone_number
    user_name = user.name
    verification_code = user.phone_verification_code

    twilio_sid = "ACd35391c08cde7926e2295d1812ada918"
    twilio_token = "44d79a36adb3d54cc15711d94d149119"
    twilio_phone_number = "6502810746"
 
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
 
    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "Hi #{user_name}. This is MathCrunch. Your verification code is #{verification_code}"
    )
  end

  # def verify_phone_number(user, code_entered)
  #   unless user.phone_verified
  #     if user.phone_verification_code == code_entered

  # end

end