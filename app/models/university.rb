class University < ApplicationRecord
  has_many :professors
  has_many :campuses

  default_scope -> { order(id: :asc) } # just an example of defatul_scope usage

  validates_presence_of :name, :acronym, :state
  validates_uniqueness_of :name, :acronym
end