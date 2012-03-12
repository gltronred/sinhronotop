class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events, :dependent => :delete_all
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events
  has_many :longtexts, :dependent => :delete_all
  has_many :links, :dependent => :delete_all
  has_and_belongs_to_many :cities

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
    self.events.select{|e| 'approved' == e.event_status.short_name}.map(&:get_moderator_emails).flatten.compact.uniq.join(',')
  end

  def get_approved_resp_emails
    self.events.select{|e| 'approved' == e.event_status.short_name}.map(&:user).map(&:email).compact.uniq.join(',')
  end

  def get_parent
    self.tournament
  end
  
  def can_play_at?(date)
    check_between_dates(date, self.game_begin, self.game_end)
  end

  def can_register?
    check_between_dates(Date.today, self.begin, self.end)
  end

  def can_submit_disp?
    check_between_dates(Date.today, self.submit_disp_from, self.submit_results_until)
  end

  def can_submit_appeal?
    check_between_dates(Date.today, self.submit_appeal_from, self.submit_appeal_until)
  end

  def can_submit_results?
    check_between_dates(Date.today, self.submit_results_from, self.submit_results_until)
  end
  
  private
  
  def check_between_dates(date, date_from, date_until)
    ret = true
    ret &&= date_from <= date if date_from
    ret &&= date_until >= date if date_until
    ret
  end

end
