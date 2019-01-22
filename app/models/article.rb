# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_and_belongs_to_many :tags
  has_many :comments, dependent: :destroy
  has_one_attached :picture

  validates :content, presence: true
  validates :title, presence: true, length: { maximum: 100 }
end
