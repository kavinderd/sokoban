module Sokoban



	class Level
		UP    = [-1,0]
		DOWN  = [1,0]
		LEFT  = [0,-1]
		RIGHT = [0,1]
		NONE  = [0,0]

		attr_reader :grid
		def initialize(level_string)
			@grid = level_string.split("\n").map{|line| line.split(//).map{|char| Tile.create(char)}}
			@move_count = 0
		end

		def to_s
			@grid.map{|row| row.join}.join("\n")
		end

		def player_position
			@grid.each_index do |row|
			  @grid[row].each_index do |col|
					if @grid[row][col].type == :player || @grid[row][col].type == :player_on_storage
						return [row, col]
					end
				end
		  end
		end


		def crate_count
			@crate_count = 0
		  @grid.each_index do |row|
				@grid[row].each_index do |col|
					if @grid[row][col].type == :crate
						@crate_count += 1
					end
				end
			end
			@crate_count
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
		
		#TODO: CLEAN THIS UP
		#TODO: COVER CASE WHEN PLAYER MOVES OFF STORAGE ONTO FREE POSITION
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
			player = player_position
			move_position = player[0] + move[0], player[1] + move[1]
			final_position= @grid[move_position[0]][move_position[1]]
			player_tile  = @grid[player[0]][player[1]]
			unless final_position.nil? || final_position.type == :invalid
				if final_position.type == :floor
					if player_tile.type == :player_on_storage
					  @grid[move_position[0]][move_position[1]], @grid[player[0]][player[1]] = Tile.create("@"), Tile.create(".")	
					else
					  @grid[move_position[0]][move_position[1]], @grid[player[0]][player[1]] = @grid[player[0]][player[1]], @grid[move_position[0]][move_position[1]]
					end
				elsif final_position.type == :storage
					player_tile = @grid[player[0]][player[1]]
					if player_tile.type == :player_on_storage
						@grid[move_position[0]][move_position[1]], @grid[player[0]][player[1]] = Tile.create("+"), Tile.create(".")
					else
					  @grid[move_position[0]][move_position[1]], @grid[player[0]][player[1]] = Tile.create('+'), Tile.create(" ")
					end
				elsif final_position.type == :crate
					next_to_final_position = move_position[0] + move[0], move_position[1] + move[1]
					next_to_final_tile = @grid[next_to_final_position[0]][next_to_final_position[1]]
					stack = []
					if next_to_final_tile.type == :floor
						stack = [Tile.create('o'), Tile.create('@'), Tile.create(' ')]
					elsif next_to_final_tile.type == :storage
						stack = [Tile.create('*'), Tile.create('@'), Tile.create(' ')]
					elsif next_to_final_tile.type == :crate || next_to_final_tile.type == :wall
						stack = [Tile.create(next_to_final_tile.to_s), Tile.create('o'), Tile.create('@')]
					end
						@grid[player[0]][player[1]] = stack.pop
						@grid[move_position[0]][move_position[1]] = stack.pop
						@grid[next_to_final_position[0]][next_to_final_position[1]] = stack.pop
				elsif final_position.type == :crate_on_storage
			    next_to_final_position = move_position[0] + move[0], move_position[1] + move[1]
					next_to_final_tile = @grid[next_to_final_position[0]][next_to_final_position[1]]
					stack = []
					player_tile = @grid[player[0]][player[1]]
					if next_to_final_tile.type == :free
						if player.type == :player_on_storage
							stack = [Tile.create("o"), Tile.create("+"), Tile.create(".")]
						else
							stack = Tile.create("o"), Tile.create("+"), Tile.create(" ")
						end
					elsif next_to_final_tile.type == :storage
						if player_tile.type == :player_on_storage
							stack = Tile.create("*"), Tile.create("+"), Tile.create(".")
						else 
							stack = Tile.create("*"), Tile.create("+"), Tile.create(" ")
						end
					elsif next_to_final_title.type == :wall || next_to_final_tile.type == :crate
				   	stack = [Tile.create(next_to_final_tile.to_s), Tile.create('*'), Tile.create('@')]
					end
						@grid[player[0]][player[1]] = stack.pop
						@grid[move_position[0]][move_position[1]] = stack.pop
						@grid[next_to_final_position[0]][next_to_final_position[1]] = stack.pop
				else
					@move_count -= 1
				end
	    end
			@move_count += 1
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
			when "."
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
