#
#  This file contains the JavaScript for the 'hello world' section.
#
#  Anything in here should be restrained to within the container of the section,
#  i.e. the <div> with the class 'hello_world'.
#

$ ->
  $('.hello_world').click ->
    alert 'The Hello World section says hello to the world!'
