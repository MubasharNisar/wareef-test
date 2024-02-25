# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :author
  has_and_belongs_to_many :talents
end
