# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :content, presence: true
  validates :content, length: { maximum: 140 }
end
