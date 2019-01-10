# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :title, presence: true
  validates :title, length: { maximum: 100 }
  validates :content, presence: true
end
