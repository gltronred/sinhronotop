class Team < ActiveRecord::Base
  has_many :results
  validates_presence_of :name
end
