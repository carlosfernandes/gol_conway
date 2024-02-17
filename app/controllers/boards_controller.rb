class BoardsController < ApplicationController
  def index
    @boards = Board.all

    render json: { boards: @boards }
  end
end
