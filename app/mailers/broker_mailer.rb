class BrokerMailer < ApplicationMailer
  default from: "from@juan_tamad.com"

  def broker_approved
    @user = params[:user]
    @url = "http://example.com/application_approved"
    mail(to: @user.email, subject: "Broker application approved!")

  end
end
