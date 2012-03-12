class City < ActiveRecord::Base
  has_many :events
  has_many :teams
  has_and_belongs_to_many :tournaments
  has_and_belongs_to_many :games

  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  def to_s
    self.name
  end

end
