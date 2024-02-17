class Generation < ApplicationRecord
  belongs_to :board

  validates :state, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :validate_state_size

  before_validation :set_order, on: :create

  private
    def set_order
      self.order = board.generations.maximum(:order).to_i + 1
    end

    def validate_state_size
      expected_size = board.size**2
      current_state_size = state&.length.to_i
      errors.add(:state, "size must be #{expected_size}") unless current_state_size == expected_size
    end
end
