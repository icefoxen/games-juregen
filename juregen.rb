#!/usr/bin/env ruby
# Some hack.
# ncurses, or SDL?
# SDL to start.
# Flexible graphics and I/O all around, though.
#
# MVC.  driver: Model.  drawer: View.  command: Controller.

require 'driver'



def run
   srand
   driver = Driver.new
   driver.mainloop
end

run
