module Routes
  def self.included( app )
    
    app.get '/' do
      haml :index
    end
    
    app.get '/register/?' do
      haml :register
    end
    
    app.post '/register/?' do
      if (params[:first_name] == "" || params[:last_name] == "" || params[:password] == "" || params[:email] == "") || Student.first(:email => params[:email])
        @message = "Registration Failed"
        if Student.first(:email => params[:email])
          @message += "That email address has already been used"
        end
        @email = params[:email]
        @last_name = params[:last_name]
        @first_name = params[:first_name]
        @password = params[:password]
        haml :register
      else
        s = Student.new
        s.email = params[:email]
        s.last_name = params[:last_name]
        s.first_name = params[:first_name]
        s.password = params[:password]
        s.save
        session[:user] = Student.auth(params[:email], params[:password])
        @message = "Registration Successful!"
        haml :index
      end
      
    end
    
  end
end