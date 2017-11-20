class University < ApplicationRecord
  has_many :professors
  has_many :campuses

  validates_presence_of :name, :acronym, :state
  validates_uniqueness_of :name, :acronym
end