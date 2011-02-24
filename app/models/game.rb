class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events, :dependent => :delete_all
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events

  validates_presence_of :num_tours, :num_questions
  validates_numericality_of :num_tours, :num_questions, :integer_only => true

  def to_s
    "этап #{self.name}"
  end

  def result_for(team)
    self.results.detect{|r|r.team == team}
  end

  def get_parent
    self.tournament
  end
  
  def can_play_at?(date)
    ret = true
    ret &&= self.game_end >= date if ret && self.game_end
    ret &&= self.game_begin <= date if ret && self.game_begin
    ret
  end

  def can_register?
    ret = true
    ret &&= self.end >= Date.today if ret && self.end
    ret &&= self.begin <= Date.today if ret && self.begin
    ret
  end

  def can_submit_disp?
    self.submit_disp_until ? self.submit_disp_until >= Date.today : true
  end

  def can_submit_appeal?
    self.submit_appeal_until ? self.submit_appeal_until >= Date.today : true
  end

  def can_submit_results?
    self.submit_results_until ? self.submit_results_until >= Date.today : true
  end


end
