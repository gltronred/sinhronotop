class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events, :dependent => :delete_all
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events

  validates_presence_of :num_tours, :num_questions, :begin, :end, :submit_disp_until, :submit_appeal_until, :submit_results_until
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

end
