module Helpers
  def self.included( app )
    app.helpers do
      def test(text)
        puts "Testing: " + text + "..."
      end
      def send_validation_code(email, code, time, first)
        pp "Sending validation code over email!!!!!!"
        pp ENV['RACK_ENV']
        message = "#{first},
Thank you for registering at ProfBingo.com. 
Please click here to complete your registration: <http://profbingo.com/validate/#{email}/#{code}/#{time.to_i}/></a>"
        message_html = "#{first},
Thank you for registering at ProfBingo.com. 
Please click here to complete your registration: <a href=\"http://profbingo.com/validate/#{email}/#{code}/#{time.to_i}/\">Verify my email address!</a>"
        if(ENV['RACK_ENV'] == 'production')
          # Running on Heroku, use sendgrid
          options = { 
            :address              => 'smtp.sendgrid.net', 
            :port                 => '587', 
            :enable_starttls_auto => true, 
            :user_name            => ENV['SENDGRID_USERNAME'],
            :password             => ENV['SENDGRID_PASSWORD'],
            :authentication       => :plain,
            :domain               => ENV['SENDGRID_DOMAIN']
          }
        else
          # Running locally, use gmail
          options = { 
            :address              => 'smtp.gmail.com', 
            :port                 => '587', 
            :enable_starttls_auto => true, 
            :user_name            => ENV['GMAIL_USERNAME'],
            :password             => ENV['GMAIL_PASSWORD'],
            :authentication       => :plain,
            :domain               => 'profbingo.com'
          }
        end
        Pony.mail(
              :from => "registration@profbingo.com",
              :to => email,
              :subject => "Your registeration of at ProfBingo.com",
              :body => message,
              :html_body => message_html,
              :port => '587',
              :via => :smtp,
              :via_options => options)
      end
    end
  end
end