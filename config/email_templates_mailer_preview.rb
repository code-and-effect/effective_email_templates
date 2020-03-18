# In Rails 4.1 and above, visit:
# http://localhost:3000/rails/mailers
# to see a preview of the following emails:

class EmailTemplatesMailerPreview < ActionMailer::Preview

  def welcome
    EmailTemplatesMailer.welcome(User.first)
  end

end
