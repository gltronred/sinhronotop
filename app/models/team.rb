class Team < ActiveRecord::Base
  has_many :results
  belongs_to :city
  validates_presence_of :name
  validates_uniqueness_of :rating_id
  validates_length_of :name, :maximum => 255
  
  def from_rating?
    self.rating_id >= 0
  end
  
  def to_s
    "#{self.name}" + (self.city ? " ("<<"#{(self.city.name)}"<<")":"")
  end
end
