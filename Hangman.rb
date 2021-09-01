require 'ruby2d'

set width:800
set height:600
$array_alphabet =["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] # letters from alphabet
WIDTH_X=Window.width/100*10
HEIGHT_Y=Window.height/100*20
set background: 'yellow'

$hash_words = {0=>"MAESTRO",1=>"BIRTHDAY",2=>"VEGETABLE",3=>"HALF",4=>"CACTUS",5=>"QUEEN",6=>"MAGIC",7=>"Birthday",
              8=>"GOBLIN",9=>"FRANKENSTEIN",10=>"RIP",11=>"CONTRACT",12=>"DOWNSIZE",13=>"INTERNET",14=>"VIBRANT",
              15=>"OBEDIENT"} # words that are part of the game
$hash_hints={"MAESTRO"=>"Master of any arts","BIRTHDAY"=>"Blow out the candles","VEGETABLE"=>"Healthy produce","HALF"=>"50%","CACTUS"=>
  "contains water", "QUEEN"=>"Elizabeth","MAGIC"=>"Abracadabra","GOBLIN"=>"Halloween Costume",
            "FRANKENSTEIN"=>"IT'S ALIVE!","RIP"=>"Written on gravestones","CONTRACT"=>
              "Legally binding agreement","DOWNSIZE"=>"Redundancy","COWORKER"=>"Colleague",
            "INTERNET"=>"World wide web","VIBRANT"=>"Full of energy","OBEDIENT"=>"Teacher's pet"} # hints that are part of the game

class Game
  attr_reader :guesses
  def initialize
    @guesses=6 # number of guesses the user has
    @shape
    @finished = false
    @word_loc = rand(15) # randomize the word each game
    @word = $hash_words[@word_loc] # get the word from the hash set
    @word_hint = $hash_hints[@word] # get the hint of the word
    $arr=[] # boolean array that checks if the right letters were guessed
    $chosen_letters=[] # to check if letters are already chosen
    $correct_letters_arr=[] # store the right letters of the word in this array
    for a in 0..@word.length-1
      $arr.push(false)
      $correct_letters_arr.push(a)
    end
    for a in 0..25
      $chosen_letters.push(false)
    end
  end

  def game_finish # finish the game
    @finished=true
  end
  def finished?
    @finished
  end
  def text_guesses
    @guess_remain=Text.new("GUESSES REMAINING: #{@guesses}")  # display guesses
  end
  def hint
    Text.new("Hint: #{@word_hint}",x:Window.width/2,y:0) # display hint
  end
  def game_over_text # display text after game ends
    if check_winner
      Text.new("You win! Press 'R' to restart",x:Window.width/2,y:100,color:'black')
    else
      Text.new("Game Over, Press 'R' to restart",x:Window.width/2,y:100,color:'black')
    end
  end
  def change_opacity(shape) # change opacity of shape
    shape.opacity=0.4
  end

  def draw(x1,y1)
    background = Image.new("img3.jpg",y:30 ) # draw background of the game
    x=WIDTH_X
    y = HEIGHT_Y
    for a in 1..$array_alphabet.size
      @shape=Square.new(x:x,y:y,size:35,color:'orange') # draw orange squares containing each letter of the alphabet
      Text.new("#{$array_alphabet[a-1]}",x:x+(x/17),y:y,size:20,color:'white')
      if @shape.contains?(x1,y1) # if the square has these coordinates from the user
        if @word.include?($array_alphabet[a-1])# if the word has this letter
          for a1 in 0..@word.length
            if $array_alphabet[a-1]==@word[a1]
              $arr[a1]=true #  true is added to this array when letter is correct
            end
          end
        else
          if $chosen_letters[a]==false
            @guesses-=1 #decrement number of guesses when the wrong letter was chosen
            $chosen_letters[a]=true # set the letter to true so the user cannot click it again
          end
        end
      end
      for c in 0..@word.length
        if $array_alphabet[a-1]==@word[c]&&$arr[c]
          change_opacity(@shape) # change opacity of the letter square so that it tells the letter  was already chosen
        end
      end

      if $chosen_letters[a]
        change_opacity(@shape)
      end
      if a%6==0
        x=WIDTH_X
        y+=HEIGHT_Y/2
      else
        x+=WIDTH_X/2
      end
    end
    line_width = 40 # width of the line the letters will float above this line
    for x in 0..@word.length-1
      if($arr[x])
        Text.new(@word[x],x:HEIGHT_Y+(line_width*x),y:HEIGHT_Y*4,size:40) # display letters if they were guessed correctly above this white line to the screen
      end
      Text.new("_",x:HEIGHT_Y+(line_width*x),y:HEIGHT_Y*4,size:60)
    end
    @guess_remain.remove
    text_guesses
  end
  def gallows # draw the gallows the man will hang from
      l1= Line.new(x1:400,y1:400,x2:600,y2:400,color:'black',size:200)
      l2= Line.new(x1:450,y1:150,x2:450,y2:400,color:'black',size:200)
      l3 = Line.new(x1:450,y1:150,x2:600,y2:150,color:'black',size:200)
      l4 = Line.new(x1:600,y1:150,x2:600,y2:200,color:'black',size:200)
      if @guesses<=5
        head=Circle.new(x: 600, y: 200, radius: 15, sectors: 32, color: 'black',)
      end
      if @guesses<=4
        body = Line.new(x1:600,y1:200,x2:600,y2:275,color:'black',size:200)
      end
      if @guesses<=3
        left_arm=Line.new(x1:600,y1:225,x2:575,y2:250,color:'black',size:200)
      end
      if @guesses<=2
        right_arm=Line.new(x1:600,y1:225,x2:625,y2:250,color:'black',size:200)
      end
      if @guesses<=1
        left_leg=Line.new(x1:600,y1:275,x2:575,y2:325,color:'black',size:200)
      end
      if @guesses==0
        right_leg=Line.new(x1:600,y1:275,x2:625,y2:325,color:'black',size:200) # draw each body part according to the number of guesses the user has
      end
  end
  def check_winner
      $arr.all?{|x| x==true} # check if all the letters of the word were chosen
  end
end

game = Game.new
x=game.text_guesses
game.draw(0,0)
game.gallows
game.hint

update do
  if game.guesses==0 || game.check_winner # check if winner or guesses is zero
    game.game_finish # end the game
    game.game_over_text
  end
end

on :key_down do |event|
  if game.finished? && event.key=='r'
    clear
    game = Game.new
    x=game.text_guesses
    game.draw(0,0)
    game.gallows
    game.hint
  end
end

on :mouse_down do |event|
  unless game.finished?
    game.draw(event.x,event.y)
    game.gallows
  end
end

show
