module Routes
  def self.included( app )
    
    app.get '/' do
      haml :index
    end
    
    app.get '/css/:file.css' do
      sass("style/#{params[:file]}".to_sym)
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
        session[:message] += "<a href=\"/validate/#{s.email}/#{s.regcode}/#{s.regtime.to_i}/\">Validate</a>"
        haml :index
      end
    end
    
    app.get '/validate/?:user?/?:code?/?:time?/?' do
      s = Student.first(:email => params[:user])
      if(!s.nil? && s.validate!(params[:code], params[:time]))
        session[:message] = "Your account is now active! Enjoy!"
        redirect('/')
      else
        haml :validateerror
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
    app.get '/controlpanel/user/edit/:user/?' do
      pp "Using specific user edit GET route"
      if(session[:user] && session[:user].admin?)
        usersearch = params[:user].gsub("*", "%")
        if(session[:user].superadmin?)
          pp "The user is a superadmin"
          search = Student.all(:email.like => usersearch)
        else
          pp "The user is not a superadmin - filtering results..."
          search = Student.all(:email.like => usersearch, :permissions.not => 'superadmin')
          pp usersearch
          pp search
        end
        # TODO: Make an actual searcher, not just exact matches...
        if(params[:user] == session[:user].email)
          session[:message] = "This is you!"
        end
        if(search.count == 1)
          if(search[0].email != usersearch)
            redirect("/controlpanel/user/edit/#{search[0].email}")
          else
            @user = search[0]
          end
          
        elsif(search.count > 1)
          @usersearch = params[:user]
          @users = search
          session[:message] = "More than one user found"
        else
          @usersearch = params[:user]
          session[:message] = "User '" + params[:user] + "' was not found, please generalize your search"
        end
        @page = 'user'
        @action = 'edit'
        haml :controlpanel
      else
        redirect '/'
      end
    end

    app.get '/controlpanel/?:page?/?:action?/?:item?/?' do
      pp "Using super awesome generic route!"
      if(session[:user] && session[:user].admin?)
        @page = params[:page]
        @action = params[:action]
        @item = params[:item]
        if(@page.nil?)
          @page = 'home'
        end
        haml :controlpanel
      else
        redirect '/'
      end
    end
    
    app.post '/controlpanel/school/add/?' do
      if(session[:user] && session[:user].admin?)
        @name = params['name']
        @short = params['short']
        @emailext = params['emailext']
        @page = 'school'
        @action = 'add'
        if(School.first(:name => params['name']))
          session[:message] = 'That school already exists!'
        elsif(School.first(:emailext => params['emailext']))
          name = School.first(:emailext => params['emailext']).name
          session[:message] = "That email extension already exists (#{name})!"
        elsif(!params['name'].nil? && params['name'] != "")
          School.create(:name => params['name'], :short => params['short'], :emailext => params['emailext'])
          session[:message] = 'School added successfully!'
          redirect('/controlpanel/school/')
        else
          session[:message] = 'You need to enter a school name!'
        end
        haml :controlpanel
      else
        redirect('/')
      end
    end
    
    app.post '/controlpanel/user/edit/:user?/?' do
      if(session[:user] && session[:user].admin?)
        
        validtypes = ['mod', 'supermod', 'admin']
        
        if(!params['email'].nil? && params['type'].nil?)
          usersearch = params['email'].gsub("*", "%")
          if(Student.all(:email.like => usersearch).count == 1)
            pp "Search: #{usersearch}"
            pp Student.all(:email.like => usersearch)
            params['email'] = Student.first(:email.like => usersearch).email
          end
          redirect('/controlpanel/user/edit/' + params['email'] + '/')
        end
        s = Student.first(:email => params['email'])
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
          pp "Saving user details..."
          s.email = params['email']
          s.first_name = params['first_name']
          s.last_name = params['last_name']
          s.valid = !params['valid'].nil?
          # Password reset request recieved
          if(!params['valid'].nil?)
            pp "I should change the pw now..."
          end
          s.save
          session[:message] = 'User successfully edited!'
        elsif(s.nil?)
          session[:message] = 'Error: You must enter a valid user!'
          @usersearch = params['email']
        else
          session[:message] = 'Error: You cannot demote yourself!'
        end
        @user = Student.first(:email => params['email'])
        @page = 'user'
        @action = 'edit'
        haml :controlpanel
      else
        redirect '/'
      end
    end
    
  end
end