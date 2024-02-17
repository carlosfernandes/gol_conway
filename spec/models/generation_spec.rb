require 'rails_helper'

RSpec.describe Generation, type: :model do
  describe 'validations' do
    let(:board) { Board.create(name: 'Board One', size: 3) }

    it 'is valid with valid attributes' do
      generation = Generation.new(state: '010101010', board: board)
      expect(generation).to be_valid
    end

    it 'is not valid without a state' do
      generation = Generation.new(board: board)
      expect(generation).not_to be_valid
    end

    it 'is not valid if state size does not match board size' do
      generation = Generation.new(state: '010101', board: board)
      expect(generation).not_to be_valid
      expect(generation.errors[:state]).to include("size must be #{board.size**2}")
    end
    
    it 'sets the correct order starting from 1 for the first generation' do
      generation = Generation.create(state: '010101010', board: board)
      expect(generation.order).to eq(1)
    end

    it 'sets the correct order on creation' do
      Generation.create(state: '010101010', board: board)
      generation = Generation.create(state: '101010101', board: board)
      expect(generation.order).to eq(2)
    end

  end
end
