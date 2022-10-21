class ApplicationMailer < ActionMailer::Base
  default from: "newsletters.notification@gmail.com"
  layout "mailer"
end
