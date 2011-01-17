class Tournament < ActiveRecord::Base
  has_many :games
  has_and_belongs_to_many :cities
  belongs_to :user
    
  def to_s
    "турнир #{self.name}"
  end

end
