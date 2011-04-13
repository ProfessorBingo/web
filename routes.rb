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
      elsif(params[:data])
        credentials = JSON.parse(params[:data])
        s = Student.new
        s.email = credentials["email"]
        s.last_name = credentials["last"]
        s.first_name = credentials["first"]
        s.pwhash = credentials["password"]
        s.regtime = Time.now
        if(s.save)
          send_validation_code(s.email, s.regcode, s.regtime, s.first_name)
          content_type :json
          { :data => {:result => 'Success'}}.to_json
        else
          jsonreturn = { :data => {:result => 'FAIL', :errors => Array.new}}
          s.errors.each do |e|
            jsonreturn[:data][:errors] << {:error => e.to_s}
          end
          content_type :json
          if(jsonreturn[:data][:errors].none?)
            jsonreturn[:data][:errors] << {:error => "Unknown Error"}
          end
          pp jsonreturn
          jsonreturn.to_json
          
        end
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
        send_validation_code(s.email, s.regcode, s.regtime, s.first_name)
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
          s = Student.first(:email => credentials["email"])
          authcode = Digest::SHA1.hexdigest(authgenstring)
          s.update(:mobileauth => authcode)
          content_type :json
          { :data => {:result => 'Success', :authcode => authcode}}.to_json
        else
          pp "User Authed Incorrectly"
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
        if(s && itemhash['authcode'] != '' && itemhash['authcode'])
          content_type :json
          { :data => {:result => 'Success'}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
      end
    end
    
    app.post '/professor/get/?' do 
      if(params[:data])
        itemhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => itemhash['authcode'])
        if(s && itemhash['authcode'] != '' && itemhash['authcode'])
          if(itemhash['departments'])
            dept_array = Array.new
            itemhash['department'].each do |dept|
              deptarray << dept['deptid'].to_i
            end
            depts = Department.all(:id => dept_array)
          else
            depts = Department.all
          end
          
          ps = Array.new
          Professor.all(:department => depts).each do |prof| 
            ps << {:id => prof.id, :name => prof.name}
          end
          content_type :json
          { :data => {:result => 'Success', :professors => ps}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
      end
    end
    
    app.post '/department/get/?' do 
      if(params[:data])
        itemhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => itemhash['authcode'])
        if(s && itemhash['authcode'] != '' && itemhash['authcode'])
          ds = Array.new
          Department.all.each do |dept| 
            ds << {:id => dept.id, :name => dept.name}
          end
          content_type :json
          { :data => {:result => 'Success', :departments => ds}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
      else
        content_type :json
        { :data => {:result => 'FAIL'}}.to_json
      end
    end
    
    app.get '/mannerism/add/?' do 
      if(session[:user])
        @page = :mannerism
        @action = :add
      end
      haml :index
    end
    
    app.post '/mannerism/add/?' do 
      if(session[:user])
        @page = :mannerism
        @action = :add
        
        profsearch = "%"+params['name'].gsub("*", "%")+"%"
        proflist = Professor.all(:name.like => profsearch)
        if(proflist.count == 1) 
          prof = proflist.first
        else
          session[:message] = "Professor #{params['name']} not found!"
          @name = params['name']
        end
        
        catsearch = "%"+params['cat'].gsub("*", "%")+"%"
        catlist = Category.all(:name.like => catsearch)
        if(catlist.count == 1) 
          cat = catlist.first
        else
          session[:message] = "Category #{params['cat']} not found!"
          @cat = params['cat']
        end
        
        # Make sure mannerism is not taken for given professor
        if(prof && Mannerism.all(:text => params['desc'], :professor => prof).count > 0)
          exists = true
        end
        
        
        if(prof && cat && exists.nil?)
          Mannerism.create(:text => params['desc'], :professor => prof, :category => cat)
          session[:message] = "Mannerism added to #{prof.name} successfully!"
          @prof = params['prof']
          @cat = params['cat']
        else
          @desc = params['desc']
          @prof = params['prof']
          @cat = params['cat']
        end        
        
      end
      haml :index
    end
    
    app.post '/play/?' do 
      if(params[:data])
        itemhash = JSON.parse(params[:data])
        s = Student.first(:mobileauth => itemhash['authcode'])
        p = Professor.first(:id => itemhash['professorid'])
        if(s && p && itemhash['authcode'] != '' && itemhash['authcode'])
          b = Board.create(:student => s, :professor => p)
          b.generate
          i = 1
          m_array = Array.new
          b.mannerism.each do |item| 
            m_array << {:location => i, :text => item.text, :itemid => item.id}
            i = i+1
          end
          content_type :json
          { :data => {:result => 'Success', :boardid => b.id, :mannerisms => m_array}}.to_json
        else
          content_type :json
          { :data => {:result => 'FAIL'}}.to_json
        end
      else
        content_type :json
        { :data => {:result => 'FAIL'}}.to_json
      end
    end
    
    app.get '/professor/add/?' do 
      if(session[:user])
        @page = :professor
        @action = :add
      end
      haml :index
    end
    
    app.post '/professor/add/?' do
      if(session[:user])
        @page = :professor
        @action = :add
        # Check valid school
        schoolsearch = "%"+params['school'].gsub("*", "%")+"%"
        schoollist = School.all(:name.like => schoolsearch)
        if(schoollist.count == 1) 
          school = schoollist.first
        else
          session[:message] = "School #{params['school']} not found!"
          @school = params['school']
        end
        # Check valid deptartment
        deptsearch = "%"+params['dept'].gsub("*", "%")+"%"
        deptlist = Department.all(:name.like => deptsearch)
        pp deptlist
        if(schoollist.count == 1) 
          dept = deptlist.first
        else
          pp "Dept not found!"
          session[:message] = "Department #{params['dept']} not found!"
          @dept = params['dept']
        end
        
        # Make sure name is not taken for given school
        if(school && Professor.all(:name => params['name'], :school => school).count > 0)
          exists = true
        end
        
        
        if(school && dept && exists.nil?)
          pp "Adding prof"
          Professor.create(:name => params['name'], :school => school, :department => dept)
          session[:message] = "Professor #{params['name']} added successfully!"
        else
          @name = params['name']
          @school = params['school']
          @dept = params['dept']
        end
        
      end
      haml :index
    end


    ### Control Panel Routes ###

    ## Search for user route
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
        if(search[0].id == session[:user].id)
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

    app.get '/controlpanel/school/edit/:school/?' do
      if(session[:user] && session[:user].admin?)
        schoolsearch = params[:school].gsub("*", "%")
        search = School.all(:name.like => schoolsearch)

        if(search.count == 1)
          if(search[0].name != schoolsearch)
            # We only found one result, but the pattern matching is not the full name
            # So, we send the user to the correct page because only one result was returned
            redirect("/controlpanel/school/edit/#{search[0].name}")
          else
            @school = search[0]
          end

        elsif(search.count > 1)
          @schoolsearch = params[:school]
          @schools = search
          session[:message] = "More than one school found"
        else
          @schoolsearch = params[:school]
          session[:message] = "School '" + params[:school] + "' was not found, please generalize your search"
        end
        @page = 'school'
        @action = 'edit'
        haml :controlpanel
      else
        redirect '/'
      end
    end

    app.get '/controlpanel/?:page?/?:action?/?:item?/?' do
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
        s = School.create(:name => params['name'], :short => params['short'], :emailext => params['emailext'])
        if(s.save)
          pp School.all
          session[:message] = 'School added successfully! (You will need to enable it for it to show up to public users!)'
          redirect('/controlpanel/school/')
        else
          
        end
        if(School.first(:name => params['name']))
          session[:message] = 'That school already exists!'
        elsif(School.first(:emailext => params['emailext']))
          name = School.first(:emailext => params['emailext']).name
          session[:message] = "That email extension already exists (#{name})!"
        elsif(!params['name'].nil? && params['name'] != "")
          
        else
          session[:message] = 'You need to enter a school name!'
        end
        haml :controlpanel
      else
        redirect('/')
      end
    end

    app.post '/controlpanel/user/edit/:user?/?' do
      session[:message] = ""
      if(session[:user] && session[:user].admin?)
        validtypes = ['mod', 'supermod', 'admin']
        if(params['studentid'].nil?)
          usersearch = params['email'].gsub("*", "%")
          if(Student.all(:email.like => usersearch).count == 1)
            pp "Search: #{usersearch}"
            pp Student.all(:email.like => usersearch)
            params['email'] = Student.first(:email.like => usersearch).email
          end
          redirect('/controlpanel/user/edit/' + params['email'] + '/')
        end
        s = Student.first(:id => params['studentid'])
        old_student_email = s.email
        # Make sure the user is not trying to change their own permissions
        if(s)
          # Extra check to make sure no one has messed with post vars for superadmins
          if(session[:user] != s)
            if(params['type'] == 'superadmin' && session[:user].superadmin?)
              s.superadmin!
            elsif(validtypes.include?(params['type']))
              s.send(params['type'] + "!")
            else
              s.standard!
            end
          elsif(params['type'] != s.get_permissions)
            session[:message] << "You cannot change your own permissions!<br />"
          end
          pp "Saving user details..."
          s.email = params['email']
          s.first_name = params['first_name']
          s.last_name = params['last_name']
          s.item_enabled = !params['valid'].nil?
          # Password reset request recieved
          if(!params['valid'].nil?)
            pp "I should change the pw now..."
          end
          # if there are no super admins, then a large problem has arisen.
          # Forbid saving of any further users because something is wrong.
          if(Student.first(:permissions => 'superadmin').nil?)
            session[:message] << 'Error: Could not save user'
          elsif(s.save)
            session[:message] << 'User successfully edited!'
            if(s.id == session[:user].id) 
              session[:user] = s
            end
            if(s.email != old_student_email)
              redirect("/controlpanel/user/edit/#{s.url_safe_email}/")
            end
          else
            session[:message] = "Error(s): "
            s.errors.each do |e|
              session[:message] << e.to_s + "<br />"
            end
          end
        else
          session[:message] = 'Error: You must enter a valid user!'
          @usersearch = params['email']
        end
        @user = Student.first(:id => params['studentid'])
        @page = 'user'
        @action = 'edit'
        haml :controlpanel
      else
        redirect '/'
      end
    end

    app.post '/controlpanel/school/edit/:school?/?' do
      if(session[:user] && session[:user].admin?)

        if(params['schoolid'].nil?)
          schoolsearch = params['name'].gsub("*", "%")
          if(School.all(:name.like => schoolsearch).count == 1)
            pp "Search: #{schoolsearch}"
            pp School.all(:name.like => schoolsearch)
            params['name'] = School.first(:name.like => schoolsearch).name
          end
          redirect("/controlpanel/school/edit/#{params['name']}/")
        end
        s = School.first(:id => params['schoolid'])
        old_school_name = s.name
        # Make sure the school actually exists
        if(!s.nil?)
          pp "Saving school details..."
          s.name = params['name']
          s.short = params['short']
          s.emailext = params['emailext']
          s.item_enabled = !params['valid'].nil?
          # Password reset request recieved
          if(s.save)
            session[:message] = 'School successfully edited!'
            if(s.name != old_school_name)
              redirect("/controlpanel/school/edit/#{s.url_safe_name}/")
            end
          else
            session[:message] = "Error(s): "
            s.errors.each do |e|
              session[:message] << e.to_s + "<br />"
            end
          end
        else
          session[:message] = 'Error: You must enter a valid school!'
          @schoolsearch = params['name']
        end
        @school = School.first(:id => params['schoolid'])
        @page = 'school'
        @action = 'edit'
        haml :controlpanel
      else
        redirect '/'
      end
    end
  end
end
