class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def forgot_password(user, reset_code)
    @user = user
    @reset_code = reset_code
    mail(to: @user.email, subject: 'Your password reset code')
  end
end
