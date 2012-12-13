# config.rb
# Config-file loader.
# Config files will be used for quite a bit, and thus have to be reasonably
# flexible.
# Maps, levels, characters...

#require 'error'

class Config
   def initialize( filename )
      @filename = filename
      @props = {}

      parse
   end

   def parse
      lines = IO.readlines( @filename )
      currentCategory = ""

      lines.each do |line|
         #puts line
         if line.index( "[" ) then
            openBrace = line.index( "[" )
            #print "Cat ", currentCategory, "\n"
            closeBrace = line.index( "]" )
            if !closeBrace then
               raise FEException( "Config file missing a ]!" )
            end 
            currentCategory = line[openBrace+1..closeBrace-1]
            #print "Cat2 ", currentCategory, "\n"
            @props[currentCategory] = {}
            #print @props, "\n"

         else
            eq = line.index( "=" )
            if eq then
               key = line[0..eq-1].strip
               val = line[eq+1..(line.length - 1)].strip
               #print key, val, "\n"
               #print @props, "\n" 
               #print currentCategory, "\n" 
               #print @props[currentCategory], "\n" 
               @props[currentCategory][key] = val
            end
         end
      end
   end

   def []( category, key )
      @props[category][key]
   end
end
