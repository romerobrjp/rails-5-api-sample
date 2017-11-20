class Discipline < ApplicationRecord
  has_and_belongs_to_many :professors, join_table: 'professors_disciplines'

  validates_presence_of :name
end
