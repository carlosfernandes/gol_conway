require 'rails_helper'

RSpec.describe GameOfLifeService, type: :model do
  describe '#next_generation' do
    let(:current_state) { '[[0, 1, 0], [0, 1, 0], [0, 1, 0]]' }
    let(:size) { 3 }
    let(:game_of_life_service) { described_class.new(current_state, size) }

    it "initializes the current board from the current state" do
      expect(game_of_life_service.instance_variable_get(:@current_board)).to eq([[0, 1, 0], [0, 1, 0], [0, 1, 0]])
    end
  
    it "updates the current board to the next generation" do
      next_gen = game_of_life_service.next_generation
      expect(next_gen).to eq([[0, 0, 0], [1, 1, 1], [0, 0, 0]])
    end
  end
end