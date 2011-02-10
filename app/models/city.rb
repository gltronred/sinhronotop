class City < ActiveRecord::Base
  has_many :events
  has_many :teams
  has_and_belongs_to_many :tournaments
  
  validates_presence_of :name, :message => ": поле не заполнено"

  def to_s
    "город #{self.name}" 
  end

end
