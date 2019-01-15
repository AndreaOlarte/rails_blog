# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments, dependent: :destroy

  validates :content, presence: true
  validates :title, presence: true, length: { maximum: 100 }
end
