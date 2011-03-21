module Routes
  def self.included( app )
    
    app.get '/' do
      haml :index
    end
    
    app.get '/register/?' do
      haml :register
    end
    
    app.post '/register/?' do
      if params[:first_name] == "" || params[:last_name] == "" || params[:password] == "" || params[:email] == ""
        @message = "Registration Failed"
        haml :register
      else
        @message = "Registration Successful!"
        haml :index
      end
      
    end
    
  end
end