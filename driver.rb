require 'level'
require 'item'
require 'character'
require 'command'
require 'globals'
require 'map'

require 'SDLPlugin'

class MessageBuffer
   attr :maxMessages, true
   attr :lastMessageRead, true

   def initialize
      @messages = []
      @maxMessages = 5
      @lastMessageRead = 0
   end
   
   def wrapString( s )
      accm = []
      while s.length > 80
         accm << s[0..80]
         s = s[80..s.length]
      end
      return accm
   end
   
   def addMessage( message )
      if message.length > 80 then
         @messages += wrapString( message )
      else
         @messages << message
      end
      
      while @messages.length > @maxMessages
         @lastMessageRead -= 1
         @messages.delete_at( 0 )
      end
      #print @messages, "\n"
      #print @lastMessageRead
   end
   
   #def getLatestMessages( count )
   #   return @messages[ @messages.length - count - 1 .. @messages.length ]
   #end
   
   #def getMessages( a, b )
   #   return @messages[a..b]
   #end
   
   
   def getNewMessages
      newmessages = @messages[@lastMessageRead..@messages.length]
      @lastMessageRead = @messages.length
      return newmessages
   end
end


class Driver
   attr :drawer
   attr :input
   attr :level
   attr :player
   attr :command
   attr :messages

   def initialize
      print "Initializing game...\n"
      @drawer = SDLDrawer.new self
      @input = SDLInput.new
      @command = Command.new self
      @level = Level.new
      
      @messages = MessageBuffer.new

      @continue = true
      @tick = 0

      makeWorld
   end

   def makeWorld
      map = @level.getCurrent
      @player = Character.new
      @player.moveTo( 1, 1 )
      map.addCharacter @player
      
      beastie = Character.new
      beastie.name = "Beastie"
      beastie.tile = 'X'
      beastie.moveTo( 5, 5 )
      beastie.color = BRed
      map.addCharacter( beastie )
      
      thing = Weapon.new
      thing.moveTo( 10, 10 )
      map.addItem( thing )
      thing = Armor.new
      thing.moveTo( 10, 10 )
      map.addItem( thing )
      thing = Armor.new
      thing.moveTo( 10, 10 )
      map.addItem( thing )
   end

   # Utility and maintainance functions.
   def doDeath
      map = @level.getCurrent
      c = map.characters
      c.each {|char| if char.hp < 1 then map.removeCharacter( char ) end }
      #newc = c.delete_if {|x| x.hp < 1}
      #@level.getCurrent.characters = newc
   end

   # *** MAIN LOOP ***
   def mainloop
      print "Doing mainloop\n"
      while @continue
         @tick += 1
         #print "Looping...\n"
         @drawer.doDrawing
         i = @input.doInput
         @command.doCommand i 

         doDeath

         $stdout.flush
      end
   end
   

   # Below here are the things that *usually* happen in response to a player
   # keystroke.
   def movePlayer( x, y )
      newx = @player.x + x
      newy = @player.y + y
      map = @level.getCurrent
      c = map.characterAt( newx, newy )
      t = map.terrainAt( newx, newy )
      if c then
         @messages.addMessage( "You attack the " + c.name + "!" )
         @player.attack( c )
      elsif t.class == DoorTile and not t.open then
         @messages.addMessage( "The door opens." )
         t.toggle
      elsif t.passable then
         @player.move( x, y )
      end
   end

   def pickUp
      x = @player.x
      y = @player.y
      map = @level.getCurrent
      items = map.itemsAt( x, y )
      if items then
         items.each { |i| @messages.addMessage( "You pick up: " + i.name ) }
         items.each { |i| i.pickUp( @player, map ) }
      end
   end

   def drop

   end

   def useTerrain
      map = @level.getCurrent
      tile = map.terrainAt( @player.x, @player.y )
      if tile.class == StairTile then
         map.removeCharacter( @player )
         @level.goToLevel( tile.dest )
         @level.getCurrent.addCharacter( @player )
         exitloc = tile.exitloc
         @player.x = exitloc[0]
         @player.y = exitloc[1]
      end
   end

   def quit
      @continue = false
   end
end
