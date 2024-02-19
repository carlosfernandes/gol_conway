require 'rails_helper'

RSpec.describe GameOfLifeService, type: :model do
  let(:board) { Board.create(name: "Test Board", size: 3) }
  let!(:current_generation) { board.generations.create(state: '[[0, 1, 0], [0, 1, 0], [0, 1, 0]]') }

  describe '#next_generation' do
    context 'when there is a current generation' do
      it 'generates the next generation' do
        service = described_class.new(board.id)
        next_generation = service.next_generation
        expect(next_generation).to be_truthy
        expect(next_generation.state).to eq '[[0, 0, 0], [1, 1, 1], [0, 0, 0]]'
      end

      it 'marks the current generation as final if no changes occur' do
        allow_any_instance_of(described_class).to receive(:is_current_board).and_return(true)
        service = described_class.new(board.id)
        next_generation = service.next_generation
        expect(next_generation.state).to eq(current_generation.state)
        expect(next_generation.final).to be_truthy
      end
    end
  end

  describe '#generations_away' do
    it 'generates the future generations' do
      service = described_class.new(board.id)
      future_generation = service.generations_away(2)
      expect(future_generation.state).to eq('[[0, 1, 0], [0, 1, 0], [0, 1, 0]]')
      expect(future_generation.order).to eq(3)
    end
  end
end