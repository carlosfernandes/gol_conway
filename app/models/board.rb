class Board < ApplicationRecord
  has_many :generations, dependent: :destroy

  validates :name, presence: true
  validates :size, numericality: { only_integer: true, greater_than_or_equal_to: 3 }
  
  before_update :delete_associations
  
  private
    def delete_associations
      self.generations.delete_all
    end
end
