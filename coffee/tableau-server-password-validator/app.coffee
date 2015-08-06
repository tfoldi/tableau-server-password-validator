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
