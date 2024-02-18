class GameOfLifeService
  def initialize(board_id, generations_away=0)
    @board = Board.find(board_id)
    @size = @board.size
    @generation = @board.generations.order(order: :desc).first
    @current_step = @generation.order
    @current_board = JSON.parse(@generation.state)
  end

  def generations_away(steps)
    last_generation = nil
    missing_steps = steps - @current_step + 1
    missing_steps.times do |i|
      generation = next_generation
      @current_board = JSON.parse(generation.state)
      last_generation = generation
    end
    last_generation
  end

  def next_generation
    return @generation if @generation.final
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
    if @current_board == next_step_board
      set_last_generation_as_final()
    else
      persist_generation(next_step_board)
    end
  end

  private
    def set_last_generation_as_final
      generation = @board.generations.last
      generation.update(final: true)
      generation
    end

    def persist_generation(generation_state, is_final=false)
      @board.generations.create(state: generation_state, final: is_final)
    end
    
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
