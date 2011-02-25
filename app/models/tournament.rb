class Tournament < ActiveRecord::Base
  has_many :games, :dependent => :delete_all
  has_many :tournament_results, :dependent => :delete_all  
  has_and_belongs_to_many :cities
  belongs_to :user
  belongs_to :calc_system
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
    
  def to_s
    "турнир #{self.name}"
  end
  
  def get_teams
    self.games.collect(&:events).flatten.collect(&:results).flatten.collect(&:team).uniq
  end
  
  def get_parent
    nil
  end
end
