class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  before_destroy :transfer_courses_to_another_author
end
