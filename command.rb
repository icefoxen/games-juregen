# The 'input' modules just get the keystrokes and turn them into a command
# string.  This takes a command string and actually executes it,
# and has all the keybindings and stuff.
#
# This lets this be subclassed/overridden/etc, 

require 'config'

class Command
   def initialize driver
      @driver = driver
      @commands = {}
      config = Config.new "data/keybindings.cfg"
      loadCommands config 
   end
   
   def loadCommands( config ) 
      addCommand( config['keys','Quit'], proc { @driver.quit } )
      #addCommand( "Q", proc { @driver.quit } )

      addCommand( config['keys','MoveLeft'], 
                 proc { @driver.movePlayer( -1,  0 ) } )
      addCommand( config['keys','MoveRight'], 
                 proc { @driver.movePlayer(  0,  1 ) } )
      addCommand( config['keys','MoveUp'], 
                 proc { @driver.movePlayer(  0, -1 ) } )
      addCommand( config['keys','MoveDown'], 
                 proc { @driver.movePlayer(  1,  0 ) } )

      addCommand( config['keys','PickUp'], proc { @driver.pickUp } )
      addCommand( config['keys','Drop'], proc { @driver.drop } )

      addCommand( config['keys','UseTerrain'], proc { @driver.useTerrain } )
   end
   
   def doCommand cmd
      if @commands.has_key? cmd then
         @commands[cmd].call
      else
         print "Key not bound: #{cmd}\n"
      end
   end

   def addCommand cmd, block
      @commands[cmd] = block
   end
end
