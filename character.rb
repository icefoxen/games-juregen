require 'globals'
require 'map'

LHAND = 0
RHAND = 1
HEAD = 2
BODY = 3
CLOAK = 4
GLOVES = 5

class Equip 
   attr :weapon, true
   attr :armor, true
   
   def netDodgeBonus
      accm = 0
      if @weapon then
         accm += @weapon.dodgeBonus
      end
      if @armor then
         accm += @armor.dodgeBonus
      end
      return accm
   end
   
   def netArmorBonus
      accm = 0
      if @weapon then
         accm += @weapon.armorBonus
      end
      if @armor then
         accm += @armor.armorBonus
      end
      return accm 
   end
   
   def netHitBonus
      accm = 0
      if @weapon then
         accm += @weapon.hitBonus
      end
      if @armor then
         accm += @armor.hitBonus
      end
      return accm
   end
   
   def netDamageBonus
      accm = 0
      if @weapon then
         accm += @weapon.damageBonus
      end
      if @armor then
         accm += @armor.damageBonus
      end
      return accm
   end 
end

class Inventory 
   attr_reader :items
   attr :gold, true

   def initialize
      @items = []
      @gold = 0
   end
end

class Character
   include Location
   attr :name, true
   attr :race

   # Stats.
   attr :strength
   attr :speed
   attr :toughness
   
   attr :intelligence
   attr :cleverness
   attr :willpower
   
   attr :power
   attr :finesse
   attr :resistance
   
   attr :hp, true
   attr :mp, true
   attr :maxhp
   attr :maxmp
   
   attr :equipment
   attr :inv


   def initialize
      initLoc
      @name = "Joe"
      @race = "Hunam"
      @equipment = Equip.new
      @inv = Inventory.new
      @hp = 10
      @maxhp = 10
      
      @strength = 10
      @speed = 10
      @toughness = 10
      @intelligence = 10
      @cleverness = 10
      @willpower = 10
      @power = 10
      @finesse = 10
      @resistance = 10

      @tile = '@'
      @color = White
   end

   def damage( amount )
      @hp -= amount
   end


   def attack( character )
      character.damage( rollDamage )
   end
   
   def dodgeVal
      statDodge = (speed / 2) + (cleverness / 4)
      return (@equipment.netDodgeBonus + statDodge) * 5
   end
   
   def armorVal
      statArmor = (toughness/4) + (willpower / 6)
      return @equipment.netArmorBonus + statArmor
   end
   
   def hitBonus
      statHit = (speed / 2) + (cleverness / 4)
      return (@equipment.netHitBonus + statHit) * 5 + 50
   end
   
   def damageBonus
      statDamage = (strength/2) + (intelligence/4)
      return @equipment.netDamageBonus + statDamage
   end

   def rollDamage
      if @equipment.weapon then
         return @equipment.weapon.rollDamage + damageBonus
      else
         return damageBonus
      end
   end

end
