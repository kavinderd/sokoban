module Sokoban


	class Level

		attr_reader :grid
		def initialize(level_string)
		  @grid = level_string.split("\n").map{|line| line.split(//)}
		end

		def self.parse_levels(file)
			@@levels = []
		  result = File.read(file).split("\n\n")
			result.each_with_index do |level_string, level_index|
				@@levels << Level.new(level_string)
			end
			@@levels
	  end

	end

	class Tile
		
		def self.creat(char)
			type = get_type(char)
		end

		def self.get_type(char)
			#TODO: Implement char
		end			

	end
	
end
