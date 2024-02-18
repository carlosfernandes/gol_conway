class Generation < ApplicationRecord
  belongs_to :board

  validates :state, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_order, on: :create

  private
    def set_order
      self.order = board.generations.maximum(:order).to_i + 1
    end
end