class JobPost < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :min_salary, numericality: true
  
  scope :search, -> (query) {
    where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  }
  # equivalent to:
  # def self.search(query)
  #   where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
end
