# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :courses, dependent: :nullify

  before_destroy :transfer_courses_to_another_author

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  private

  def transfer_courses_to_another_author
    new_author = Author.where.not(id:).first

    if new_author
      courses.update_all(author_id: new_author.id)
    else
      throw(:abort)
    end
  end
end
