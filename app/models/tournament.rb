class Tournament < ActiveRecord::Base
  has_many :games, :dependent => :delete_all
  has_many :longtexts, :dependent => :delete_all
  has_many :links, :dependent => :delete_all

  has_and_belongs_to_many :cities
  belongs_to :user
  belongs_to :calc_system
  has_and_belongs_to_many :tags
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
    
  def to_s
    "турнир #{self.name}"
  end
  
  def get_teams
    self.games.collect(&:events).flatten.collect(&:results).flatten.map(&:team).uniq
  end
  
  def get_cities
    cities = self.every_city ? City.all : self.cities
    cities.sort_by{|c|c.name}
  end
  
  def validate_cap_name?
    self.cap_name_required && !self.needTeams
  end
  
  def get_parent
    nil
  end
end
