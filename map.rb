# Map.
# We're gonna keep it fixed-size at the moment, so it could still
# theoretically fit on a normal 80x24 console.

# A mixin, I suppose.  That IS basically what I need.
module Location
   attr :x, true
   attr :y, true
   
   attr :tile, true
   attr :color, true

   def initLoc
      @x = 0
      @y = 0
   end

   def moveTo( x, y )
      @x = x
      @y = y
   end

   def move( x, y )
      @x += x
      @y += y
   end

   def moveToward( x, y )
      return
   end
end


class BaseTile
   attr :tile, true
   attr :color, true
   attr :passable, true

   def initialize
      @tile = '?'
      @color = BRed
      @passable = false
   end

   def to_s
      return @tile
   end
end

class FloorTile < BaseTile
   def initialize
      super
      @tile = '.'
      @color = White
      @passable = true
   end
end

class WallTile < BaseTile
   def initialize
      super
      @tile = '#'
      @color = White
      @passable = false
   end
end

class StairTile < BaseTile
   attr_writer :dest
   attr_reader :dest

   attr :exitloc, true
   def initialize
      super
      @tile = '>'
      @color = White
      @passable = true
      @dest = 0

      @exitloc = [1,1]
   end
end

class DoorTile < BaseTile
   attr_reader :open
   attr_writer :open

   def initialize
      super
      @tile = '+'
      @color = BBrown
      @passable = false
      @open = false
   end

   def toggle
      if @open then
         @open = false
         @passable = false
         @tile = '+'
      else
         @open = true
         @passable = true
         @tile = '/'
      end
   end
end


class Map
   attr :width
   attr :height
   attr :terrain
   attr :unknownMask
   attr :items
   attr_reader :characters
   attr_writer :characters

   def initialize
      @width = 78
      @height = 20
      # It's organized as an array of rows.
      @terrain = Array.new( @height, nil )
      for i in 0..@height
         @terrain[i] = Array.new( @width, nil )
      end
      genTerrain

      @unknownMask = Array.new( @height, nil )
      for i in 0..@height
         @unknownMask[i] = Array.new( @width, true )
      end

      @characters = []
      @items = []

   end

   def genTerrain
      # Make big room
      for i in 0..77
         for j in 0..19
            if i == 0 or i == 77 then
               @terrain[j][i] = WallTile.new
            elsif j == 0 or j == 19 then
               @terrain[j][i] = WallTile.new
            else
               @terrain[j][i] = FloorTile.new
            end
         end
      end
      # Make random pillars and such in it
      80.times do
         x = Integer( rand * 78 )
         y = Integer( rand * 20 )
         @terrain[y][x] = WallTile.new
         r = rand
         if r < 0.33 then
            @terrain[y+1][x] = WallTile.new
         elsif r > 0.66 then
            @terrain[y][x+1] = WallTile.new
         end
      end

      @terrain[3][3] = DoorTile.new
   end

   
   def terrainAt( x, y )
      return @terrain[y][x]
   end
   
   # XXX: Exploration.
   def graphicAt( x, y )
      tile = terrainAt( x, y )
      c = characterAt( x, y )
      i = itemsAt( x, y )
      if c then 
         return c
      elsif i then
         return i[0]
      end
      return tile
   end
   

   def addItem( itm )
#      if not itemsAt( itm.x, itm.y ) then
#         @items << itm
#      end
      @items << itm
   end

   def removeItem( itm )
      @items.delete( itm )
   end

   def addCharacter( char )
      @characters << char
      #print "Character added: ", @characters.length, "\n"
   end

   def removeCharacter( char )
      @characters.delete( char )
   end

   def itemsAt( x, y )
      accm = []
      @items.each { |item|
         if item.x == x and item.y == y then
            accm << item
         end
      }
      if accm == [] then
         return false
      else
         return accm
      end
   end

   def characterAt( x, y )
      for i in 0...@characters.length 
         char = @characters[i]
         #print "Man at #{char.x}, #{char.y}: #{x}, #{y}\n"
         if char.x == x && char.y == y then
            return char
         end
      end
      return false
   end

   def explore( x, y, r )
   end

   # Erm, the stair needs to know which location to come out at...
   # And, the stair tiles need to indicate directionality.
   # Both of those are hard, 'cause the stair tile itself knows bloody
   # nothing about where it is or what level it's on.
   # Perhaps pairs of UpStair and DownStair classes?
   # Inter-Level stairs, also...  ugh.
   def addStair( x, y, connection, exitloc, isUp=false )
      @terrain[y][x] = StairTile.new
      @terrain[y][x].dest = connection
      @terrain[y][x].exitloc = exitloc
      if isUp then
         @terrain[y][x].tile = '<'
      end
   end
end
