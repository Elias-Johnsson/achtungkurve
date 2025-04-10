require 'ruby2D'
set title: "Curv crash"

set width: 1500
set height: 600

$list_of_players = [1,1,1]

class StartScreen
  def initialize()
    Rectangle.new(x:0,y:0,width: 1500, height: 800, color:'teal', z:1)
    Rectangle.new(x:200,y:100, width:200, height: 100,color:'white', z:2)
    Rectangle.new(x:650,y:100, width:200, height: 100,color:'green', z:2)
    Rectangle.new(x:1100,y:100, width:200, height: 100,color:'black', z:2)
    Square.new(x:700, y:350, size:100, color:'red', z: 2)
  end
end

class GameScreen
  def initialize()
    i = 0
    while i < $list_of_players.length
      $list_of_players[i] = Player.new()
      i += 1
    end
  end
  def rotate_player(direction,player_index)
    $list_of_players[player_index].rotate(direction)
  end
  def move_players_forward()
    i = 0
    while i < $list_of_players.length
      $list_of_players[i].draw()
      $list_of_players[i].direct()
      $list_of_players[i].move_forward()
      i += 1
    end
  end
end

class Player
  def initialize()
    @x = rand(400..1100)
    @y = rand(200..400)
    @x_speed = 0
    @y_speed = 0
    @players = []
    @color = ['red','blue','green']
    @rotate = 360
  end
  def draw()
    i = 0
    while i < $list_of_players.length
      @players[i] = Square.new(x:@x, y:@y, size:3,color: @color[i])
      i += 1
    end
  end
  def rotate(direction)
    case direction
    when :left
      @rotate -= 1
    when :right
      @rotate += 1
    end
  end
  def direct()
    @x_speed = Math.sin(@rotate * Math::PI/ 180)
    @y_speed = Math.cos(@rotate *  Math::PI/ 180)
  end
  def move_forward()
    @x += @x_speed
    @y += @y_speed
  end
end
@currentScreen = GameScreen.new()
#startscreen = StartScreen.new()

on :key_held do |action|
  if action.key == 'a'
    @currentScreen.rotate_player(:left,0)
  elsif action.key == 's'
    @currentScreen.rotate_player(:right,0)
  end
  if action.key == 'g'
    @currentScreen.rotate_player(:left,1)
  elsif action.key == 'h'
    @currentScreen.rotate_player(:right,1)
  end
  if action.key == 'k'
    @currentScreen.rotate_player(:left,2)
  elsif action.key == 'l'
    @currentScreen.rotate_player(:right,2)
  end
end
update do
  #startscreen
  @currentScreen.move_players_forward()
end
show
