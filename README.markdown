#Version Control Paradigms#
JD Hill
Eric Stokes
Jimmy Theis

#Professor Bingo - Ruby Web Application#

The general idea of the Professor Bingo project is as follows: an application consisting of a web service with a usable web front-end, as well as a mobile Android application will provide a sort of Bingo variant where instead of randomly drawing card locations from a mechanical ball blower, game board squares will be marked complete when professors demonstrate certain mannerisms during class. Students will connect either to the web interface or to the mobile app and enter a game session when their class begins. As time passes and their professor demonstrates his or her mannerisms, students will mark their game boards until one of them achieves a Bingo. This student’s account will be credited with a score for this win.

__Note__: Passwords and usernames are used for example only.

#Valid JSON Posts#

The following sections detail the valid POST variables for device login.

##Login##
###URL: /login###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "email": "student@school.edu", 
        "password": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success", 
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
    }

__Failure__

__Note:__ _authcode_ value will be returned if the result is a failure

    {
        "result": "FAIL"
    }

##Logout##
###URL: /logout###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success"
    }

__Failure__

__Note:__ This condition will occur if an _authcode_ has already been logged out 

    {
        "result": "FAIL"
    }

##Register##
###URL: /register###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "email": "student@school.edu", 
        "password": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd",
        "first": "John",
        "last": "Doe"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success"
    }

__Failure__

__Note:__ _authcode_ value will be returned if the result is a failure

    {
        "result": "FAIL"
    }

##Status##
###URL: /status###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success"
    }

__Failure__

__Note:__ This condition will occur if an _authcode_ is __NOT__ valid

    {
        "result": "FAIL"
    }

##Get Categories for School##
###NOT YET IMPLEMENTED###
###URL: /category/get###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success", 
        "categories": 
        [
            {
                "id": "1", 
                "name": "Science"
            }, 
            {
                "id": "2", 
                "name": "Math"
            }
        ]
    }

__Failure__

__Note:__ This condition will occur if an _authcode_ is __NOT__ valid

    {
        "result": "FAIL"
    }

##Get Professors for School##
###NOT YET IMPLEMENTED###
###URL: /professor/get###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd"
        (, "categories": 
        [
            {"categoryid": "1"}, 
            {"categoryid": "2"}
        ])
    }

The parenthesis show optional parameters.

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success", 
        "professors": 
        [
            {
                "id": "1",
                "name": "Sriram Mohan"
            },
            {
                "id": "2",
                "name": "Curt Clifton"
            }
        ]
    }

__Failure__

__Note:__ This condition will occur if an _authcode_ is __NOT__ valid

    {
        "result": "FAIL"
    }


##Get Board##
###NOT YET IMPLEMENTED###
###URL: /board/get###
The JSON object should be posted in 'data' as follows:

    data => 
    {
        "authcode": "8bdf9067f19ae9f2614c62676792b1ecf70f47dd", 
        "professorid": "1"
    }

and will return a JSON object that looks like this:

__Success__

    {
        "result": "Success",
        "boardid": "1"
        "mannerisms": 
        [
            {
                "location": "1"
                "text": "The professor throws a marker"
                "itemid": "1"
            },
            {
                "location": "2"
                "text": "The phrase 'Valid Point' is said by the professor"
                "itemid": "45"
            },
            {
                "location": "3"
                "text": "The professor trips"
                "itemid": "3"
            },
            
            ...
            
            {
                "location": "25"
                "text": "The professor throws a marker... and makes it in the trash can"
                "itemid": "28"
            },
        ]
    }

__Failure__

__Note:__ This condition will occur if an _authcode_ is __NOT__ valid

    {
        "result": "FAIL"
    }
