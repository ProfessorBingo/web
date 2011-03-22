#Version Control Paradigms#
JD Hill
Eric Stokes
Jimmy Theis

#Professor Bingo - Ruby Web Application#

The general idea of the Professor Bingo project is as follows: an application consisting of a web service with a usable web front-end, as well as a mobile Android application will provide a sort of Bingo variant where instead of randomly drawing card locations from a mechanical ball blower, game board squares will be marked complete when professors demonstrate certain mannerisms during class. Students will connect either to the web interface or to the mobile app and enter a game session when their class begins. As time passes and their professor demonstrates his or her mannerisms, students will mark their game boards until one of them achieves a Bingo. This student’s account will be credited with a score for this win.

#Valid JSON Posts#

The following sections detail the valid POST variables for device login.

##Login##
###URL: /login###
The JSON object should be posted in 'data' as follows:

    data => {"email":"student@school.edu", "password":"passw0rd"}

and will return a JSON object that looks like this:

__Success__

    {"result":"Success", "authcode":"8bdf9067f19ae9f2614c62676792b1ecf70f47dd"}

__Failure__

__Note:__ _authcode_ value will be returned if the result is a failure

    {"result":"FAIL"}


##Logout##
###URL: /logout###
The JSON object should be posted in 'data' as follows:

    data => {"authcode":"8bdf9067f19ae9f2614c62676792b1ecf70f47dd"}

and will return a JSON object that looks like this:

__Success__

    {"result":"Success"}

__Failure__

__Note:__ This condition will occur if an _authcode_ has already been logged out 

    {"result":"FAIL"}
    
##Status##
**NOT LIVE YET**
###URL: /status###
The JSON object should be posted in 'data' as follows:

    data => {"authcode":"8bdf9067f19ae9f2614c62676792b1ecf70f47dd"}

and will return a JSON object that looks like this:

__Success__

    {"result":"Success"}

__Failure__\*\*\*

__Note:__ This condition will occur if an _authcode_ is __NOT__ valid

    {"result":"FAIL"}
