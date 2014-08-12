$:.unshift('.')
$:.unshift("./lib")
$:.unshift('..')
$:.unshift('../lib')

require 'sokoban'

s = Sokoban::Level.parse_levels('sokoban_levels.txt')
level =s.first
level.move("UP")
level.move("LEFT")
level.move("LEFT")
level.move("LEFT")
level.move("LEFT")
level.move("LEFT")
level.move("LEFT")



