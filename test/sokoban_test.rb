$:.unshift('.')
$:.unshift('./lib')
$:.unshift('..')
$:.unshift('../lib')
require 'minitest/autorun'
require 'sokoban'

class SokobanTest < MiniTest::Test

	def test_level_parsing
		level = Sokoban::Level.parse(Sokoban::Level::LEVEL_01)
		result = level.split("\n")
		assert_equal result.first, "    #####"
	end
end
