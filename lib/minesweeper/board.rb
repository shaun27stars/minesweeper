module Minesweeper

  class Board
    
    attr_reader :mines

    def initialize(size=10, mines=10)
      @board = Array.new(size) {Array.new(size, 0)}
      @mines = mines

      mines.times do |n|
        begin
          x,y = [rand(size), rand(size)]
        end while @board[y][x]==:mine
        
        @board[y][x] = :mine

        # @board[y-1][x-1] += 1 unless y==0 || x==0 || @board[y-1][x-1] == :mine
        # @board[y-1][x]   += 1 unless y==0 || @board[y-1][x]   == :mine
        # @board[y-1][x+1] += 1 unless y==0 || x==size-1 || @board[y-1][x+1] == :mine
        # @board[y][x-1]   += 1 unless x==0 || @board[y][x-1]   == :mine
        # @board[y][x+1]   += 1 unless x==size-1 || @board[y][x+1]   == :mine
        # @board[y+1][x-1] += 1 unless y==size-1 || x==0 || @board[y+1][x-1] == :mine
        # @board[y+1][x]   += 1 unless y==size-1 || @board[y+1][x]   == :mine
        # @board[y+1][x+1] += 1 unless y==size-1 || x==size-1 || @board[y+1][x+1] == :mine
        



        ((x-1)..(x+1)).each do |x_offset|
          ((y-1)..(y+1)).each do |y_offset|
            unless x_offset < 0 || x_offset == size || 
                   y_offset < 0 || y_offset == size || 
                   @board[y_offset][x_offset]==:mine
              @board[y_offset][x_offset] += 1
            end
          end
        end
      end

      
    end

    def result(pos)
      x,y = pos
      @board[y][x]
    end

    def size
      @board.size
    end
    
    
  end
end