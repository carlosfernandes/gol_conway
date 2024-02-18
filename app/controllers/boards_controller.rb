class BoardsController < ApplicationController
  def index
    @boards = Board.all

    render json: { boards: @boards.select(:id, :name) }
  end

  def create
    @board = Board.new(name: board_params[:name], size: board_params[:size])
    @board.generations.build(state: board_params[:initial_state])

    if @board.save
      render json: { id: @board.id, name: @board.name }, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  private
    def board_params
      params.require(:board).permit(:name, :size, :initial_state)
    end
end
