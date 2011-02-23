class Team < ActiveRecord::Base
  has_many :results
  belongs_to :city
  validates_presence_of :name
  validates_uniqueness_of :rating_id
  
  def to_s
    "#{self.name} (#{self.city.name if self.city})" 
  end
end
