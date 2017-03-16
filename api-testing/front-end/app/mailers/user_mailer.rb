class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: @user['user']['email'], subject: "Account activation"
  end
end
