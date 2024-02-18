class GameOfLifeService
  def initialize(current_state, size)
    @size = size
    @current_board = JSON.parse(current_state)
  end

  def next_generation
    matrix_size = @current_board.length
    next_step_board = Array.new(matrix_size) { Array.new(matrix_size, 0) }
    for i in 0..@current_board.length-1
      for j in 0..@current_board[0].length-1
        current_cell = @current_board[i][j]
        live_neighbors_count = live_neighbors(i, j)

        if current_cell == 0 && live_neighbors_count == 3
          next_step_board[i][j] = 1
        end

        if current_cell == 1 && live_neighbors_count < 2
          next_step_board[i][j] = 0
        end

        if current_cell == 1 && live_neighbors_count > 3
          next_step_board[i][j] = 0
        end

        if current_cell == 1 && (live_neighbors_count == 2 || live_neighbors_count == 3)
          next_step_board[i][j] = current_cell
        end
      end
    end
    @current_board = next_step_board
  end

  private
    def live_neighbors(row, col)
      neighbors = []

      (-1..1).each do |delta_x|
        (-1..1).each do |delta_y|
          next if delta_x == 0 && delta_y == 0

          if row + delta_x >= 0 && row + delta_x < @current_board.length && col + delta_y >= 0 && col + delta_y < @current_board[0].length
              neighbors << @current_board[row + delta_x][col + delta_y] if @current_board[row + delta_x][col + delta_y] == 1
          end
        end
      end

      neighbors.count
    end
end
