module Routes
  def self.included( app )
    
    app.get '/' do
      haml :index
    end
    
    app.get '/register/?' do
      if (session[:user])
        redirect '/'
      else
        haml :register
      end
    end
    
    app.post '/register/?' do
      if (params[:first_name] == "" || params[:last_name] == "" || params[:password] == "" || params[:email] == "") || Student.first(:email => params[:email])
        session[:message] = "Registration Failed"
        if Student.first(:email => params[:email])
          session[:message] += " - That email address has already been used"
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
        session[:message] = "Registration Successful!"
        haml :index
      end
    end
    
    app.get '/login/?' do
      haml :login
    end
    
    app.post '/login/?' do
      pp "Found Login POST"
      pp params
      session[:user] = Student.auth(params[:email], params[:password])

      # Check for basic auth
      if(session[:user])
        redirect '/'
      elsif(params[:data]) # Check for a json login
        jdata = params[:data]
        credentials = JSON.parse(jdata)
        if(Student.sauth(credentials["email"], credentials["password"]))
          authgenstring = credentials["password"] + credentials["email"] + Time.now.to_s
          s = Student.first(credentials["email"])
          authcode = Digest::SHA1.hexdigest(authgenstring)
          s.update(:mobileauth => authcode)
          content_type :json
          { :data => {:authcode => authcode}}.to_json
        else
          content_type :json
          { :data => {:authcode => 'FAIL'}}.to_json
        end
      else
        session[:message] = "Invalid username or password"
        haml :login
      end
    end
    
    app.get '/logout/?' do
      session[:user] = nil
      redirect '/'
    end
    
    app.post '/logout/?' do
      if(params[:data])
        pwhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => pwhash['authcode'])
        if(s)
          s.update(:mobileauth => "INVALID")
          content_type :json
          { :data => {:authcode => 'Success'}}.to_json
        else
          content_type :json
          { :data => {:authcode => 'FAIL'}}.to_json
        end
        
      end
    end
    
  end
end