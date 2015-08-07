# Tableau Server 9.0 Password Validator

## The Goal

We’d like to enforce the password policy for regular users without modifying too many things on the Tableau Server. If the password is not strong enough then the “Submit button” will be disabled in the same way when the two passwords don’t match. Also we need to indicate what’s wrong with the password like “Hey Jim, where are your capital letters?!”.

Okay, enough from the words, here is my version. Click on the picture to be part of the miracle in HD:
![Users cannot have weak passwords](http://databoss.starschema.net/wp-content/uploads/2015/08/unnamed.gif)
Users cannot have weak passwords
Lovely? Do you need it? Okay, you’re just two lines away from getting it.

## TL;DR – Just give me the code and the instructions

1. [Download my pre-packaged javascript code](https://raw.githubusercontent.com/tfoldi/tableau-server-password-validator/master/dist/tableau-password-validator-full.js)
2. Append its contents to %ProgramFiles%\Tableau\Tableau Server\9.1\vizportalclient\public\vizportal.min.js
3. Test & Enjoy

## How does it work?
Here is the complete source code which tells more than thousand words:


    _ = require 'underscore'
    #$ = require 'jquery'
     
    messages = require './messages.jade'
     
    MIN_LENGTH = 8
     
    POLICIES =
      too_short: (pwd)-> (pwd.length < MIN_LENGTH)
      no_lowercase: (pwd)-> !/[a-z]/.test(pwd)
      no_uppercase: (pwd)-> !/[A-Z]/.test(pwd)
      no_numbers: (pwd)-> !/[0-9]/.test(pwd)
     
     
    password_checker = (password)->
      _.without( ((if v(password) then k else null) for k,v of POLICIES), null)
     
     
    # Add the template for the error messages
    add_password_template = (selector)->
      $(selector).before( messages() )
     
    do_password_checking = (password_selector, button_selector=".tb-details-button-cell .tb-outline-button", error_msg_selector=".password-error-messages")->
      $(password_selector).keydown ->
        # Hide all error messages
        $('li', error_msg_selector).hide()
        # check the password
        password_errors = password_checker( $(@).val() )
        # disable the button if necessary
        $(button_selector).toggle(_.isEmpty(password_errors))
        # show the error messages
        for k in password_errors
          $(".password_#{k}", error_msg_selector).show()
     
    $(document).on 'click', '[tb-test-id="change-password-link"]', ->
      add_password_template("tr[ng-if='requireCurrentPassword']")
      do_password_checking( "input[tb-test-id='edit-new-password-textbox-input']" )

As you can see from line 6 to 12 we just defined our rules as regexp in an array which is shows or hides the change password button according its evaluated true/false value. You can extend or change these rules as you want.

For the messages I made a jade template:

    tr
      td(colspan="3")
        style
          | .password-error-messages { background: #fcc; padding:0; margin:0; }
          | .password-error-messages li { color: red; font-size: 12px; padding: 1em 0.5em; }
     
        .password-error-messages
          ul
            li.password_too_short(style="display:none") Password must contain at least 8 characters
            li.password_no_lowercase(style="display:none") Password must contain lowercase letters
            li.password_no_uppercase(style="display:none") Password must contain uppercase letters
            li.password_no_numbers(style="display:none") Password must contain numeral characters

This is pretty straightforward, too.


[Full documentation is on databoss.starschema.net](http://databoss.starschema.net/tableau-9-0-vizportal-and-forcing-password-security-databoss-version/)

with BSD License
