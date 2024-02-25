# frozen_string_literal: true

class Talent < ApplicationRecord
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :learning_paths
end
