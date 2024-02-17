class GenerationsController < ApplicationController
  before_action :set_board
  
  def show
    @generation = @board.generations.find_by(order: params[:order])

    render json: { generation: @generation }
  end

  private
    def set_board
     @board = Board.find(params[:board_id])
    end
end
