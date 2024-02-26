# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
