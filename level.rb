# level.rb
# Okay...  Each map is a single floor.
# This, on the other hand, is a collection of floors linked together.
# This...  I may need a wrapper around the maps to provide meta-info like
# which floor it is, special features, random events, and so on.
# But for now, this should work.

require 'map'

class Level
   attr :name
   attr :maps

   def initialize
      @name = "Catacombs"
      @maps = []
      @currentMap = 0
      initMaps
   end

   def initMaps
      5.times { @maps << Map.new }

      for i in 0..(@maps.length-1)
         if i != (@maps.length-1) then
            @maps[i].addStair( 11, 11, i+1, [40,15] )
         end
         if i != 0 then
            @maps[i].addStair( 40, 15, i-1, [11,11], true ) 
         end
      end
   end

   def getCurrent
      return @maps[@currentMap]
   end

   def goToLevel( l )
      @currentMap = l
   end
end
