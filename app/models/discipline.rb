class Discipline < ApplicationRecord
  has_and_belongs_to_many :professors

  validates_presence_of :name
end
