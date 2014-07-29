module Sokoban
	WALL = "#"
	CHARACTER = "@"
	CRATE = "o"
	OPEN_FLOOR = " "
	STORAGE = "."
	CRATE_ON_STORAGE = "*"
	MAN_ON_STORAGE = "+"
   
  class Game
    
		def initialize
    end
  end

	class Level
		LEVEL_01 = "0"
		LEVEL_02 = "12"
		LEVEL_03 = "23"

		def self.parse(level)
			file = File.readlines('../sokoban_levels.txt')
			
		  
		end
	end
end
