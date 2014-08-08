module Sokoban



	class Level
		UP    = [-1,0]
		DOWN  = [1,0]
		LEFT  = [0, -1]
		RIGHT = [0,1]
		NONE  = [0,0]

		attr_reader :grid
		def initialize(level_string)
			@grid = level_string.split("\n").map{|line| line.split(//).map{|char| Tile.create(char)}}
		end

		def to_s
			@grid.map{|row| row.join}.join("\n")
		end

		def player_position
			@grid.each_index do |row|
			  @grid[row].each_index do |col|
					if @grid[row][col].type == :player || @grid[row][col] == :player_on_storage
						return [row, col]
					end
				end
		  end
		end

		def [](row, col)
			@grid[row][col]
		end

		def self.parse_levels(file)
			@@levels = []
		  result = File.read(file).split("\n\n")
			result.each_with_index do |level_string, level_index|
				@@levels << Level.new(level_string)
			end
			@@levels
	  end
		
		def move(movement)
      move = case movement
					   when 'UP'
							 UP
						 when 'DOWN'
							 DOWN
						 when 'LEFT'
							 LEFT
						 when 'RIGHT'
							 RIGHT
						 else
							 NONE
						 end
			puts move
			player = player_position
			move_position = player[0] + move[0], player[1] + move[1]
			puts move_position
			puts player
			final_position= @grid[move_position[0]][move_position[1]]
			puts final_position
			unless final_position.nil? || final_position.type == :invalid
				if final_position.type == :floor
					puts @grid
					@grid[move_position[0]][move_position[1]], @grid[player[0]][player[1]] = @grid[player[0]][player[1]], @grid[move_position[0]][move_position[1]]
					puts @grid
				else
				end
	    end
			puts to_s
		end

	end

	class Tile
		
		attr_reader :type, :char
		def self.create(char)
			type = get_type(char)
			tile = new(char, type)
		end

		def initialize(char, type)
			@char = char
			@type = type
		end

		def to_s
			@char
		end

		def self.get_type(char)
			case char 
			when "#"
				:wall
			when " "
				:floor
			when "@"
				:player
			when "o"
				:crate
			when "-"
				:storage
			when "+"
				:player_on_storage
			when "*"
				:crate_on_storage
			else
				:invalid
			end
		end			

	end
	
end
