class Event < ActiveRecord::Base
  belongs_to :game
  belongs_to :city
  has_many :disputeds, :dependent => :delete_all
  has_many :appeals, :dependent => :delete_all
  has_many :results, :dependent => :delete_all
  has_many :plays, :dependent => :delete_all
  belongs_to :user
  belongs_to :event_status
  belongs_to :moderation, :class_name => 'User'

  validates_presence_of :city_id, :user_id, :date
  validates_format_of :moderator_email, :moderator_email2, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_nil => true, :allow_blank => true
  validates_length_of :more_info, :maximum => 1023, :allow_nil => true, :allow_blank => true
  validates_presence_of :game_time, :if => :should_validate_game_time?

  def validate
    unless self.game.can_play_at?(self.date)
      errors.add_to_base game.game_dates_to_s
    end
  end
  
  def shift_local_indexes(changed_result, added) 
    self.results.each do |r|
      if r!= changed_result && r.local_index >= changed_result.local_index
        added ? r.local_index += 1 : r.local_index -= 1
        r.save
      end
    end
  end
  
  def update_status(new_status)
    self.event_status = new_status
    self.last_change = "Статус заявки изменен"
    self.save(false)
  end

  def update_moderator_id(id)
    if id
      self.moderator_name = nil
      self.moderator_email = nil
      self.moderator_email2 = nil
    else
      self.moderation_id = nil
    end
  end

  def to_s
    "игра в городе #{self.city.name} #{self.date.loc}"
  end

  def get_parent
    self.game
  end

  def get_moderator_name
    self.moderation ? self.moderation.name : self.moderator_name
  end
  
  def get_moderator_emails
    [get_moderator_email, get_moderator_email2].compact.uniq
  end

  def get_moderator_email
    self.moderation ? self.moderation.email : self.moderator_email
  end
  
  def get_moderator_email2
    if self.moderation || !self.moderator_email2 || self.moderator_email2.empty?
      nil
    else
      self.moderator_email2
    end
  end

  def should_validate_game_time?
    self.game.tournament.time_required
  end

  def get_report_status
    report_status = "#{self.disputeds.empty? ? '-' : '+'} / #{self.appeals.empty? ? '-' : '+'} / #{self.results.empty? ? '-' : '+'}"
    if self.game.tournament.needTeams
      report_status << " / #{self.plays.empty? ? '-' : '+'}"
    end
  end

  def validate_event_date
    self.date >= Date.today
  end
end
