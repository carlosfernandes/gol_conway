class GenerationsController < ApplicationController
  before_action :set_board, :set_generation

  def show
    if @generation
      render json: { generation: @generation }
    else
      generations_away(params[:generations_away]) if params[:generations_away]
      next_generation unless params[:generations_away]
      render json: { generation: @generation }
    end
  end

  private
    def set_board
     @board = Board.find(params[:board_id])
    end

    def set_generation
      @generation = @board.generations.find_by(order: params[:order])
    end

    def generations_away(steps)
      gol_service = GameOfLifeService.new(params[:board_id])
      @generation = gol_service.generations_away(steps.to_i)
    end

    def next_generation
      gol_service = GameOfLifeService.new(params[:board_id])
      @generation = gol_service.next_generation
    end
end
