
class HumanPlayer
  
  attr_accessor :stdin
  def name
    "Human Player"
  end

  def take_turn(state)
    # puts "mines remaining: #{mines_remaining.inspect}"
    puts "co-ordinates (x,y)?"
    x, y, flag = stdin.gets.split(",").map{ |a| a.strip.to_i }
  end
  
  
end