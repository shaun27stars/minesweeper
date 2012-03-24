require 'minesweeper/board'

module Minesweeper

  class Game
    attr_reader :game_over

    def initialize(player)
      @board = Board.new
      @player = player
      @state = Array.new(@board.size) {Array.new(@board.size, :unknown)}
    end

    def tick
      pos = @player.take_turn(@state)
      if pos.size==3
        flag = pos[2]
        pos = pos.take(2)
      end
      flag = false if flag==0

      if flag
        @state[pos[1]][pos[0]] = :flag
        return
      end

      result = update_state(pos)

      if result==:mine
        @game_over = :lost
      end

      if @state.flatten.select{|p| [:unknown, :flag].include?(p)}.size == @board.mines
        @game_over = :won
      end
    end
    
    def name
      @player.name
    end

    def report
      @state
    end

    private

    def update_state(pos)
      return unless [:unknown, :flag].include?(@state[pos[1]][pos[0]])
      result = @board.result(pos)
      @state[pos[1]][pos[0]] = result
      if result==0
        update_state([pos[0]-1, pos[1]]) if pos[0]>0
        update_state([pos[0]+1, pos[1]]) if pos[0]<@board.size-1
        update_state([pos[0], pos[1]-1]) if pos[1]>0
        update_state([pos[0], pos[1]+1]) if pos[1]<@board.size-1

        update_state([pos[0]-1, pos[1]-1]) if pos[0]>0 && pos[1]>0
        update_state([pos[0]-1, pos[1]+1]) if pos[0]>0 && pos[1]<@board.size-1
        update_state([pos[0]+1, pos[1]-1]) if pos[1]<@board.size-1 && pos[1]>0
        update_state([pos[0]+1, pos[1]+1]) if pos[1]<@board.size-1 && pos[1]<@board.size-1

      end
      return result
    end
    
  end
end