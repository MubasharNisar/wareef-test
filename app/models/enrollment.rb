# app/models/enrollment.rb
class Enrollment < ApplicationRecord
  belongs_to :talent
  belongs_to :course
  enum status: { in_progress: 0, complete: 1 }
end