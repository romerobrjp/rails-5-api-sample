class Campus < ApplicationRecord
  has_many :professors
  belongs_to :university

  validates_presence_of :name, :city
  validates_uniqueness_of :name
end
