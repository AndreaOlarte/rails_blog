# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, foreign_key: :author_id
  has_many :comments, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true
end
