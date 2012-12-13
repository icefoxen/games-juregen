
require 'curses'
require 'drawer'
require 'input'

class CursesDrawer < Drawer
   def initialize
      print "Beep!\n"
      Curses.init_screen
      Curses.cbreak
      #Curses.flash
      a = ''
      b = Curses.getch
      while a != b do
         a = Curses.getch
         Curses.addch a
      end
      print "Bop: "
      print b
         
      #print Ncurses.newterm
   end
end

