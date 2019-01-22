class Tag < ApplicationRecord
  has_and_belongs_to_many :articles

  validates :category, presence: true, length: { maximum: 25 }
end
