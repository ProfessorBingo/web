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
      if (session[:user])
        redirect '/'
      elsif (params[:first_name] == "" || params[:last_name] == "" || params[:password] == "" || params[:email] == "") || Student.first(:email => params[:email])
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
          { :data => {:result => 'Success', :authcode => authcode}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
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
        itemhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => itemhash['authcode'])
        if(s && itemhash['authcode'] != "")
          s.update(:mobileauth => "")
          content_type :json
          { :data => {:result => 'Success'}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
        
      end
    end
    # Look into ways of refactoring this and logout, only 1 line difference
    app.post '/status/?' do
      if(params[:data])
        itemhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => itemhash['authcode'])
        if(s && itemhash['authcode'] != '')
          content_type :json
          { :data => {:result => 'Success'}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
      end
    end
    
    
    ### Control Panel Routes ###    
    
    app.get '/controlpanel/edituser/:user/?' do
      if(session[:user] && session[:user].admin?)
        search = Student.all(:email => params[:user]).count
        # TODO: Make an actual searcher, not just exact matches...
        if(params[:user] == session[:user].email)
          session[:message] = "This is you!"
        end
        if(search == 1)
          @user = Student.first(:email => params[:user])
        elsif(search > 1)
          @usersearch = params[:user]
          session[:message] = "More than one user found"
        else
          @usersearch = params[:user]
          session[:message] = "User '" + params[:user] + "' was not found, please generalize your search"
        end
        @page = 'edituser'
        haml :controlpanel
      else
        redirect '/'
      end
    end
    
    app.get '/controlpanel/?:page?/?' do
      if(session[:user] && session[:user].admin?)
        @page = params[:page]
        if(@page.nil?)
          @page = 'home'
        end
        haml :controlpanel
      else
        redirect '/'
      end
    end
    
    app.post '/controlpanel/edituser/:user?/?' do
      if(session[:user] && session[:user].admin?)
        validtypes = ['mod', 'supermod', 'admin']
        s = Student.first(:email => params['email'])
        pp params
        pp !params['email'].nil?
        pp params['type'].nil?
        if(!params['email'].nil? && params['type'].nil?)
          pp "Redirecting..."
          pp '/controlpanel/edituser/' + params['email'] + '/'
          redirect('/controlpanel/edituser/' + params['email'] + '/')
        end
        
        # Make sure the user is not trying to change their own permissions
        if(session[:user] != s && !s.nil?)
          # Extra check to make sure no one has messed with post vars for superadmins
          if(params['type'] == 'superadmin' && session[:user].superadmin?)
            s.superadmin!
          elsif(validtypes.include?(params['type']))
            s.send(params['type'] + "!")
          else
            s.standard!
          end
          s.save
        elsif(s.nil?)
          session[:message] = 'Error: You must enter a valid user!'
          @usersearch = params['email']
        else
          session[:message] = 'Error: You cannot demote yourself!'
        end
        @user = Student.first(:email => params['email'])
        @page = 'edituser'
        haml :controlpanel
      else
        redirect '/'
      end
    end
    
  end
end