require 'ruby2D'
set title: "Curve crash"

set width: 1500
set height: 600
#set fullscreen: true

$list_of_players = []
$num_of_players = []
$player_postitons = []
$player_scores = []
$color = ['red', 'blue', 'green', 'yellow']
@game_started = false



class StartScreen
  def initialize()
    $first_loop = true
  end
  def draw()
    Rectangle.new(x:0,y:0,width: 1500, height: 800, color:'teal', z:1)
    Rectangle.new(x:375,y:100, width:200, height: 100,color:'red', z:2)
    Text.new("Press 1, to select player",x:380,y:135,size:15,color:'black', z:3)
    Rectangle.new(x:575,y:100, width:200, height: 100,color:'blue', z:2)
    Text.new("Press 2, to select player",x:580,y:135,size:15,color:'black', z:3)
    Rectangle.new(x:770,y:100, width:200, height: 100,color:'green', z:2)
    Text.new("Press 3, to select player",x:775,y:135,size:15,color:'black', z:3)
    Rectangle.new(x:970,y:100, width:200, height: 100,color:'yellow', z:2)
    Text.new("Press 4, to select player",x:975,y:135,size:15,color:'black', z:3)
    Rectangle.new(x:650, y:350,width:200, height:100, color:'black', z: 2)
    Text.new("Press Space to start game", x:655, y:390, size:15, color:'white', z:3)
  end

end

class GameScreen
  def initialize()
    @first_loop = true
    @game_screen = Rectangle.new(x:200,y:10, width:700, height:500,color: '#202020' ,z:1)
    @score_board = Rectangle.new(x:1350, y:10, width:100, height:400, color: 'black', z:1)
    i = 0
    while i < $num_of_players.length
      Text.new($player_scores[i], x:1400, y:(i*30),size:20, color: $color[i], z:2)
      $list_of_players[i] = Player.new(i)
      i += 1
    end
  end
  def reset()
    $player_postitons = [[],[],[],[]]
    @first_loop = true
    @game_screen = Rectangle.new(x:200,y:10, width:700, height:500,color: '#202020' ,z:1)
    @score_board = Rectangle.new(x:1350, y:10, width:100, height:400, color: 'black', z:1)
    i = 0
    while i < $num_of_players.length
      Text.new($player_scores[i], x:1400, y:(i*30),size:20, color: $color[i], z:2)
      $list_of_players[i] = Player.new(i)
      i += 1
    end
  end
  def tot_reset()
    $player_postitons = []
    $player_scores = []
    $list_of_players = []
    $num_of_players = []
    $first_loop = true
  end
  def check_player_collision()
    i = 0 
    while i < $num_of_players.length
      if $list_of_players[i].player_collision(i) || $list_of_players[i].self_collision(i)
        $list_of_players[i].kill_player()
      end
      i += 1
    end
  end
  def check_round_winner()
    i = 0
    @num_of_alive = 0
    while i < $player_scores.length
      if $list_of_players[i].is_alive?()
        @winner_index = i
        @num_of_alive += 1
      end
      i += 1
    end
    if @num_of_alive == 1
      sleep(0.5)
      $player_scores[@winner_index] += 1
      return true
    end
    return false
  end
  def check_winner()
    i = 0
    while i < $player_scores.length
      if $player_scores[i] == 3
        puts "Player #{i+1} wins"
        return true
      end
      i += 1
    end
    return false
  end
  def rotate_player(direction,player_index)
    $list_of_players[player_index].rotate(direction)
  end
  def check_border_collision()
    i = 0
    while i < $num_of_players.length
      if $list_of_players[i].out_of_bounds?(@game_screen,i) 
        $list_of_players[i].kill_player()
      end
      i += 1
    end
  end
  def move_players_forward()
    i = 0
    while i < $num_of_players.length
      if $list_of_players[i].is_alive?()
        $list_of_players[i].direct()
        $list_of_players[i].move_forward()
        $list_of_players[i].draw()
        $player_postitons[i] << ($list_of_players[i].g_pos(i))
      end
      i += 1
    end
  end
end

class Player
  def initialize(index)
    @x = rand(300..700)
    @y = rand(70..450)
    @color = $color[index]
    @alive = true
    @x_speed = 1
    @y_speed = 1
    @squares = []
    @player_position = []
    @rotate = rand(0..360)
  
  end
  def draw()
    i = 0
    while i < $num_of_players.length
      #@squares[i] = Square.new(x:@x, y:@y, size:3,color:@color, z:2)
      @squares[i] = Line.new(x1:@x, y1:@y,x2:@x + @x_speed,y2:@y + @y_speed, width:5,color:@color, z:2)
      i += 1
    end
  end
  def kill_player()
    @alive = false
  end
  def is_alive?()
    if @alive
      return true
    else 
      return false
    end
  end
  def out_of_bounds?(border,player_index)
    return @squares[player_index].x <= border.x || @squares[player_index].x >= (border.x + border.width) || @squares[player_index].y <= border.y || @squares[player_index].y >= (border.y + border.height)
  end
  def g_pos(i)
    #@player_position = [@squares[i].x1, @squares[i].y1, @squares[i].x2, @squares[i].y2, @squares[i].x3, @squares[i].y3,@squares[i].x4, @squares[i].y4]
    
    return @player_position
  end
  def rotate(direction)
    case direction
    when :left
      @rotate -= 3
    when :right
      @rotate += 3
    end
  end
  def player_collision(i)
    j = 0
    while j < $player_postitons.length
      if j == i
        j += 1
        next
      end
      k = 0
      while k < $player_postitons[j].length
        pos = $player_postitons[j][k]
        if pos && pos.length == 8
          if @squares[i].contains?($player_postitons[j][k][0], $player_postitons[j][k][1]) || 
            @squares[i].contains?($player_postitons[j][k][2], $player_postitons[j][k][3]) || 
            @squares[i].contains?($player_postitons[j][k][4], $player_postitons[j][k][5]) || 
            @squares[i].contains?($player_postitons[j][k][6], $player_postitons[j][k][7])
              return true
          end
        end
        k += 1
      end
      j += 1
    end
  end
  def self_collision(i)
    j = 0
    while j < $player_postitons[i].length - 5
      if j == 0
        j += 1
        next
      end
      if @squares[i].contains?($player_postitons[i][j][0], $player_postitons[i][j][1]) || 
        @squares[i].contains?($player_postitons[i][j][2], $player_postitons[i][j][3]) || 
        @squares[i].contains?($player_postitons[i][j][4], $player_postitons[i][j][5]) || 
        @squares[i].contains?($player_postitons[i][j][6], $player_postitons[i][j][7])
          return true
      end
      j += 1
    end
    return false
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
@startscreen = StartScreen.new()
@currentScreen = GameScreen.new()

on :key_down do |choice|
  if choice.key == '1'
    $num_of_players[0] = 1
    $player_postitons[0] = []
    $player_scores[0] = 0
  end
  if choice.key == '2'
    $num_of_players[1] = 1
    $player_postitons[1] = []
    $player_scores[1] = 0
  end
  if choice.key == '3'
    $num_of_players[2] = 1
    $player_postitons[2] = []
    $player_scores[2] = 0
  end
  if choice.key == '4'
    $num_of_players[3] = 1
    $player_postitons[3] = []
    $player_scores[3] = 0
  end
  if choice.key == 'space'
    if $num_of_players != []
      @game_started = true
      @first_loop = true
    end
  end
end

on :key_held do |action|
  if action.key == 's'
    if $list_of_players[0] == nil
      next
    else
      @currentScreen.rotate_player(:left,0)
    end
  elsif action.key == 'a'
    if $list_of_players[0] == nil
      next
    else
      @currentScreen.rotate_player(:right,0)
    end
  end
  if action.key == 'h'
    if $list_of_players[1] == nil
      next
    else
      @currentScreen.rotate_player(:left,1)
    end
  elsif action.key == 'g'
    if $list_of_players[1] == nil
      next
    else
      @currentScreen.rotate_player(:right,1)
    end
  end
  if action.key == 'l'
    if $list_of_players[2] == nil
      next
    else
      @currentScreen.rotate_player(:left,2)
    end
  elsif action.key == 'k'
    if $list_of_players[2] == nil
      next
    else
      @currentScreen.rotate_player(:right,2)
    end
  end
  if action.key == 'm'
    if $list_of_players[3] == nil
      next
    else
      @currentScreen.rotate_player(:left,3)
    end
  elsif action.key == 'n'
    if $list_of_players[3] == nil
      next
    else
      @currentScreen.rotate_player(:right,3)
    end
  end
end

update do
  if @game_started
    if $first_loop
      clear
      $first_loop = false
      @currentScreen = GameScreen.new()
    end
    @currentScreen.move_players_forward()
    @currentScreen.check_border_collision()
    @currentScreen.check_player_collision()
    if @currentScreen.check_round_winner
      clear
      @currentScreen = GameScreen.new()
      @currentScreen.reset()
      if @currentScreen.check_winner() 
        clear
        @game_started = false
        p "benis"
        $player_scores = []
        @currentScreen.tot_reset()
      end
    end 
  else
    if !@startscreen.draw()
      @startscreen.draw()
    end
  end
end
show