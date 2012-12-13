require 'map'
require 'globals'

class Item
   include Location
   attr :weight
   attr :name, true
   
   attr :hitBonus
   attr :damageBonus
   attr :dodgeBonus
   attr :armorBonus

   attr :tile
   attr :color
   
   def initialize
      @name = "Random Item"
      @weight = 1
      @broken = false
      
      @tile = "+"
      @color = BWhite
   end
   

   # Just give "false" for the map if they're not actually picking it up off the
   # ground
   def pickUp( char, map )
      addToInventory( char )
      if map then
         map.removeItem( self )
      end
   end
   
   def drop( char, map )
      removeFromInventory( char )
      @x = char.x
      @y = char.y
      map.addItem( self )
   end
   
   def addToInventory( char )
      char.inv.items << self
   end
   
   def removeFromInventory( char )
      char.inv.items.delete( self )
   end
end



class Weapon < Item
   def initialize
      super
      @name = "Random Weapon"
      @weight = 10
      @tile = '{'
      @color = BRed
      #damage = 2d4+1, expressed this way
      @damageTimes = 2
      @damageBase = 4
      @damageBonus = 1
   end

   def rollDamage
      accm = 0
      @damageTimes.times { accm += Integer( 1 + (rand * @damageBase) ) }
      return accm + @damageBonus
   end
end 


class Armor < Item
   def initialize
      super
      @name = "Random Armor"
      @weight = 20
      @tile = ']'
      @color = BRed
   end
   
end 
