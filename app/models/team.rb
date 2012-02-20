class Team < ActiveRecord::Base
  has_many :results
  has_many :plays
  has_many :players

  belongs_to :city
  validates_presence_of :name
  validates_uniqueness_of :rating_id
  validates_length_of :name, :maximum => 255
  
  def Team.merge(real, duplicate)
    raise "real is #{real}" unless real && real.kind_of?(Team)
    raise "duplicate is #{duplicate}" unless duplicate && duplicate.kind_of?(Team)
    raise "duplicate has rating-id" if duplicate.rating_id

    #real.players = (real.players + duplicate.players).uniq
    #real.plays = (duplicate.plays + real.plays).uniq
    #real.results = (duplicate.results + real.results).uniq
    duplicate.players.each {|pl| pl.team = real; pl.save! }
    duplicate.plays.each {|play| play.team = real; play.save! }
    duplicate.results.each {|r| r.team = real; r.save! }
    #Team.transaction do
      real.save!
    duplicate.destroy
    #end
  end
  
  def from_rating?
    self.rating_id >= 0
  end
  
  def to_s
    "#{self.name}#{", #{self.city.name}" if self.city}"
  end
  
  def to_s_full
    "#{self.name}#{", #{self.city.name}" if self.city}, в рейтинге #{self.rating_id ? self.rating_id :  'нет'}"
  end
end
