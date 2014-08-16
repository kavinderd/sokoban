module Sokoban

	class Application
		def initialize
			Level.parse_levels("../sokoban_levels.txt")
			@game = Game.new.play
		end

		def move(move)
			@game.move(move)
		end

	end
	
  class Game
		def initialize()
		end
		def play(level=0)
			@level = Level.start(level)	
			@status = :playing
			self
		end

		def move(move)
			move_status = @level.move(move)
		end
	end


	class Level
		UP    = [-1,0]
		DOWN  = [1,0]
		LEFT  = [0,-1]
		RIGHT = [0,1]
		NONE  = [0,0]

		def self.start(level=0)
			@@levels[level]
		end

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
		
		def move(movement)
      move = case movement
					   when 'w'
							 UP
						 when 's'
							 DOWN
						 when 'a'
							 LEFT
						 when 'd'
							 RIGHT
						 else
							 NONE
						 end
			player = player_position
			move_position = player[0] + move[0], player[1] + move[1]
			final_position= @grid[move_position[0]][move_position[1]]
			player_tile  = @grid[player[0]][player[1]]
			return unless can_move_to?(final_position)
			move_data = MoveData.new(player_tile, player, final_position, move_position, move)
			if final_position.static?
				standard_move(move_data)
			else
				multi_move(move_data)
			end
			puts "Game over" if crate_count == 0
			puts to_s
		end
		
		def set(tile:, position:)
			@grid[position[0]][position[1]] = tile
		end

		def can_move_to?(tile)
			return true unless tile.nil? || tile.type == :invalid || tile.type == :wall
		end

		def standard_move(move_data)
			replacement_tile = clear_player_from_tile(move_data.actor_tile)  		
			player_tile = prepare_player_for_tile(move_data.destination_tile)
			set(tile: replacement_tile, position: move_data.actor_position)
			set(tile: player_tile, position: move_data.destination_position)
			@move_count += 1
		end

		def object_move(move_data)
			replacement_tile = clear_object_from_tile(move_data.actor_tile)
			object_tile = prepare_object_for_tile(move_data.destination_tile)
			set(tile: replacement_tile, position: move_data.actor_position)
			set(tile: object_tile, position: move_data.destination_position)
		end

		def multi_move(move_data)
			next_to_final_position = [move_data.destination_position[0] + move_data.move[0], move_data.destination_position[1] + move_data.move[1]]
			next_to_final_tile = @grid[next_to_final_position[0]][next_to_final_position[1]]
			return unless can_move_to?(next_to_final_tile)
			move = MoveData.new(move_data.destination_tile, move_data.destination_position, next_to_final_tile, next_to_final_position)
			object_move(move)			
			destination_tile = @grid[move_data.destination_position[0]][move_data.destination_position[1]]
			final_move = MoveData.new(move_data.actor_tile, move_data.actor_position, destination_tile, move_data.destination_position)
			standard_move(final_move)
		end

		def clear_object_from_tile(tile)
		  if tile.type == :crate
				p 'returning'
				Tile.create(" ")
			elsif tile.type == :crate_on_storage
				Tile.create(".")
			end
		end

		def prepare_object_for_tile(tile)
			if tile.type == :storage
				Tile.create("*")
			else
				Tile.create("o")
			end
		end
	
		def clear_player_from_tile(player_tile)
			if player_tile.type == :player_on_storage
				Tile.create(".")
			else
				Tile.create(" ")
			end
		end

		def prepare_player_for_tile(tile)
			if tile.type == :storage
				Tile.create("+")
			else
				Tile.create("@")
			end
		end
	end

	class MoveData < Struct.new(:actor_tile,:actor_position, :destination_tile, :destination_position, :move); end;

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

		def static?
			[:storage, :wall, :floor].include?(@type)
		end

		def player?
			@type == :player || @type = :player_on_storage
		end

		def crate?
			@type == :crate || @type == :crate_on_storate
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
