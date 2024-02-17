require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'validations' do
    it 'is valida with valid attributes' do
      board = Board.new(name: "Board One", size: 4)
      expect(board).to be_valid
    end

    it 'is not valid without a name' do
      board = Board.new(name: '', size: 5)
      expect(board).not_to be_valid
    end

    it 'is not valid without size' do
      board = Board.new(name: 'Board One')
      expect(board).not_to be_valid
    end

    it 'is not valid with non-integer size' do
      board = Board.new(name: 'Board One', size: 'abc')
      expect(board).not_to be_valid
    end

    it 'is not valid with size less than or equal to 3' do
      board = Board.new(name: 'Board One', size: 2)
      expect(board).not_to be_valid
    end
  end

  
  describe 'associations' do
    let(:board) { Board.create(name: 'Board One', size: 3) }
    
    it 'has many generations' do
      expect(board).to respond_to(:generations)
    end

    it 'deletes associated generations before update' do
      board.generations.create(state: '010101010')
      board.generations.create(state: '101010010')
      
      expect { board.update(name: 'Updated Board') }.to change { Generation.count }.from(2).to(0)
    end

    it 'does not delete other boards\' generations' do
      other_board = Board.create(name: 'Other Board', size: 3)
      other_board.generations.create(state: '010101010')
      
      expect { board.update(name: 'Updated Board') }.not_to change { other_board.generations.count }
    end
  end
end
