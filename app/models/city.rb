class City < ActiveRecord::Base
  has_many :events
  has_many :teams
  has_and_belongs_to_many :tournaments
  
  validates_presence_of :name

  def to_s
    "#{self.name} (#{self.country})" 
  end

end
