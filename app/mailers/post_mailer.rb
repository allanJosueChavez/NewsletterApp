class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.post_created.subject
  #
  def post_created
    @greeting = "Hi"
    @author = params[:author]
    @post = params[:post]
    @users = User.joins("INNER JOIN subscriptions ON subscriptions.users_id = users.id AND subscriptions.newsletters_id = #{@post.newsletters_id}")
    mail(
      to: @users.pluck(:email),
      subject: "There's a new post on the newsletter you are subscribed!"
    )
  end
end
