
require 'sdl'
require 'drawer'
require 'globals'
require 'input'

class SDLDrawer < Drawer
   def initialize driver
      print "Initializing SDL drawer...\n"
      SDL.init( SDL::INIT_EVERYTHING )
      SDL::TTF.init
      SDL::WM::setCaption( 'juregen', '' )

      @driver = driver
      @screen = SDL::setVideoMode( 640, 350, 16, SDL::SWSURFACE ) 
      @font = SDL::TTF.open( "data/cour.ttf", 12 )
      @linesize = @font.lineSkip
      @charsize = 7
      
      @xoffset = 10
      @yoffset = 5
   end

   def doDrawing

      @screen.fillRect( 0, 0, 800, 600, [0,0,0] )

      drawMap
      drawStatbar
      drawMessages
      
      @screen.flip
   end
   
   # This draws all the messages in the buffer
   def drawMessages
      messages = @driver.messages.getNewMessages
      #print "Messages: ", messages, " \n"
      while messages.length > 2
         displayMessages( messages[0], "[more...]" )
         messages.delete_at( 0 )
         @screen.flip
         @driver.input.waitForInput
      end
      displayMessages( messages[0], messages[1] )
   end

   # This only displays two specific messages.
   def displayMessages( msg1, msg2 )
      if msg1 == nil then msg1 = "" end
      if msg2 == nil then msg2 = "" end
      @screen.fillRect( @xoffset, @yoffset, 
                        @xoffset+@charsize*80, @linesize*2, [0,0,0] )
      @font.drawBlendedUTF8( @screen, msg1, @xoffset, @yoffset,
                              255, 255, 255 )
      @font.drawBlendedUTF8( @screen, msg2, @xoffset, @yoffset+@linesize,
                              255, 255, 255 )
   end
   
   
   def drawMap
      m = @driver.level.getCurrent
      w = m.width
      h = m.height
      
      mapYOffset = @yoffset + @linesize * 2 
      # Draw map.
      for y in 0...h
         for x in 0...w
            tile = m.graphicAt( x, y )
            char = tile.tile
            color = tile.color
            @font.drawBlendedUTF8( @screen, char, @xoffset+x*@charsize,
                                    mapYOffset+y*@linesize,
                                    color[0], color[1], color[2] )
         end
      end
   end
   
   
   # Lets figure out what we want the stat bar to look like, first.
   # 0         1         2         4         5         6         7         
   # 0123456789012345678901234567890123456789012345678901234567890123456789
   # MyNameHere...... St:XX Sp:XX To:XX In:XX Cl:XX Wi:XX Po:XX Fi:XX Re:XX
   # HP:nnn/NNN MP:nnn/NNN  DV/AV:DV/AV  Exp:LL/eeeeee  LOCALE  OTHER.....
   def drawStatbar
      line1 = @yoffset + @linesize * 22
      line2 = @yoffset + @linesize * 23
   
      p = @driver.player
      # I need... columns.
      # Printf and format suddenly seem very useful, and I don't have 'em.
      # Statstr should be... 54 characters long.  I think.

      statstr1 = sprintf( "%-16s St:%2d Sp:%2d To:%2d In:%2d Cl:%2d Wi:%2d Po:%2d Fi:%2d Re:%2d", p.name, p.strength, p.speed, p.toughness, p.intelligence, p.cleverness, p.willpower, p.power, p.finesse, p.resistance )

      statstr2 = sprintf( "HP:%3d/%-3d MP:%3d/%-3d DV/AV:%2d/%-2d LV:%2d/%02d%%", p.hp, p.maxhp, p.mp, p.maxmp, p.dodgeVal, p.armorVal, 1, 0 )
      
      @font.drawBlendedUTF8( @screen, statstr1, @xoffset, line1, 255, 255, 255 )
      @font.drawBlendedUTF8( @screen, statstr2, @xoffset, line2, 255, 255, 255 )
      
      
   end

end



class SDLInput < Input
   def initialize
      super
      print "Initializing SDL input...\n"
      # Why in the world is it UNICODE instead of Unicode?
      SDL::Event.enableUNICODE
   end


   # This... sorta works, and is rather horrible.
   # First, MODIFIER KEYS!  AAAUGH!  They cause their own keypress events,
   # which we have to ignore, and figure out if any are pressed with evt.mod
   # later.
   # Second, capitalization and such. the #unicode method takes care of that,
   # thankfully.
   # Third...  F-keys, arrow keys, etc.
   def waitForInput
      while evt = SDL::Event2.wait
         case evt
         when SDL::Event2::KeyDown
            # Check if it's not a modifier key, ie shift or alt
            if evt.sym < 256 then
               return evt
            end 
         end
      end
   end

   def parseEvent evt
      c = evt.unicode.chr
      #if evt.mod & SDL::Key::MOD_SHIFT then
      #   c.capitalize!
      #end
      #print c, "\n"
      
      # Check for arrow keys, F buttons, etc.
      return c
   end

   def doInput
       return parseEvent( waitForInput )
   end
end

