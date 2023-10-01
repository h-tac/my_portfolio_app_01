class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? "自転車空気入れマップ <#{ENV['MAIL_ADDRESS']}>" : "from@example.com"
  layout "mailer"
end
