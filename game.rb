
require 'ruby2D'
set title: "Curv crash"

set width: 1500
set height: 600

$list_of_players = [1,1]
@first_loop = true

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
    @game_screen = Rectangle.new(x:10,y:10, width:1300, height:575,color: '#202020' ,z:1)
    i = 0
    while i < $list_of_players.length
      $list_of_players[i] = Player.new()
      i += 1
    end
  end
  def rotate_player(direction,player_index)
    $list_of_players[player_index].rotate(direction)
  end
  def check_border_collision()
    i = 0 
    while i < $list_of_players.length
      if $list_of_players[i].out_of_bounds?(@game_screen,i) 
        $list_of_players[i].kill_player(i)
      end
      i += 1
    end
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
    @x = rand(200..1000)
    @y = rand(200..400)
    @x_speed = 0
    @y_speed = 0
    @squares = []
    @color = ['red','blue','green']
    @rotate = rand(0..360)
  
  end
  def draw()
    i = 0
    while i < $list_of_players.length
      @squares[i] = Square.new(x:@x, y:@y, size:3,color: @color[i], z:2)
      #Line.new(x1: @x, y1: @y,x2: (@x + @x_speed), y2: (@y + @y_speed),width: 5,color: 'lime')
      i += 1
    end
    def kill_player(player_index)
      $list_of_players.delete_at(player_index)
      puts "benis #{player_index}"
    end
  end
  def out_of_bounds?(border,player_index)
    return @squares[player_index].x <= border.x1 || @squares[player_index].x >= border.x2 || @squares[player_index].y <= border.y2 || @squares[player_index].y >= border.y4
  end
  def rotate(direction)
    case direction
    when :left
      @rotate -= 3
    when :right
      @rotate += 3
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
    if $list_of_players[0] == nil
      next
    else
      @currentScreen.rotate_player(:left,0)
    end
  elsif action.key == 's'
    if $list_of_players[0] == nil
      next
    else
      @currentScreen.rotate_player(:right,0)
    end
  end
  if action.key == 'g'
    if $list_of_players[1] == nil
      next
    else
      @currentScreen.rotate_player(:left,1)
    end
  elsif action.key == 'h'
    if $list_of_players[1] == nil
      next
    else
      @currentScreen.rotate_player(:right,1)
    end
  end
  if action.key == 'k'
    if $list_of_players[2] == nil
      next
    else
      @currentScreen.rotate_player(:left,2)
    end
  elsif action.key == 'l'
    if $list_of_players[2] == nil
      next
    else
      @currentScreen.rotate_player(:right,2)
    end
  end
end

update do
  #startscreen
  @currentScreen.move_players_forward()
  @currentScreen.check_border_collision()
end
show
