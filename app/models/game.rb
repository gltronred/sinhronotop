class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events, :dependent => :delete_all
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events
  has_many :longtexts, :dependent => :delete_all

  validates_presence_of :num_tours, :num_questions
  validates_numericality_of :num_tours, :num_questions, :integer_only => true
  validates_length_of :name, :maximum => 255

  def to_s
    "этап #{self.name}"
  end
  
  def game_dates_to_s
    ret = []
    ret << "не раньше #{self.game_begin.loc}" if self.game_begin
    ret << "не позже #{self.game_end.loc}" if self.game_end
    ret.join ', '
  end

  def result_for(team)
    self.results.detect{|r|r.team == team}
  end
  
  def get_approved_moderator_emails
    self.events.select{|e| 'approved' == e.event_status.short_name}.map(&:get_moderator_email).uniq.join(',')
  end

  def get_approved_resp_emails
    self.events.select{|e| 'approved' == e.event_status.short_name}.map(&:user).map(&:email).uniq.join(',')
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
    #self.submit_disp_until ? self.submit_disp_until >= Date.today : true
    ret = true
    ret &&= self.submit_disp_from <= Date.today if self.submit_disp_from
    ret &&= self.submit_disp_until >= Date.today if self.submit_disp_until
    ret
  end

  def can_submit_appeal?
    #self.submit_appeal_until ? self.submit_appeal_until >= Date.today : true
    ret = true
    ret &&= self.submit_appeal_from <= Date.today if self.submit_appeal_from
    ret &&= self.submit_appeal_until >= Date.today if self.submit_appeal_until
    ret
  end

  def can_submit_results?
    #self.submit_results_until ? self.submit_results_until >= Date.today : true
    ret = true
    ret &&= self.submit_results_from <= Date.today if self.submit_results_from
    ret &&= self.submit_results_until >= Date.today if self.submit_results_until
    ret
  end

end
