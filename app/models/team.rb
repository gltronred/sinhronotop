class Team < ActiveRecord::Base
  has_many :results
  has_many :plays
  has_many :players

  belongs_to :city
  validates_presence_of :name
  validates_uniqueness_of :rating_id, :allow_blank => true, :allow_nil => true
  validates_length_of :name, :maximum => 255
  
  def Team.merge(real, duplicate)
    raise "real is #{real}" unless real && real.kind_of?(Team)
    real.errors.add "duplicate is #{duplicate}" unless duplicate && duplicate.kind_of?(Team)
    real.errors.add "duplicate has rating-id #{duplicate.rating_id}" if duplicate.rating_id && duplicate.rating_id > 0
    return false unless real.errors.empty?

    duplicate.players.each {|pl| pl.team = real; pl.save! }
    duplicate.plays.each {|play| play.team = real; play.save! }
    duplicate.results.each {|r| r.team = real; r.save! }
    real.save!
    duplicate.destroy
  end
  
  def from_rating?
    rating_id && rating_id >= 0
  end
  
  def get_rating_id
    from_rating? ? rating_id : ''
  end
  
  def to_s
    "#{self.name}#{", #{self.city.name}" if self.city}"
  end
  
  def to_s_full
    "#{self.name}#{", #{self.city.name}" if self.city}, в рейтинге #{self.rating_id ? self.rating_id :  'нет'}"
  end
end
