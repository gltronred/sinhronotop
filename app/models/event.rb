class Event < ActiveRecord::Base
  belongs_to :game
  belongs_to :city
  has_many :disputeds, :dependent => :delete_all
  has_many :appeals, :dependent => :delete_all
  has_many :results, :dependent => :delete_all
  belongs_to :user
  belongs_to :event_status
    
  validates_presence_of :city_id, :moderator_name, :moderator_email, :user_id, :date
  validates_format_of :moderator_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :moderator_email, :moderator_name, :maximum => 255
  validates_length_of :more_info, :maximum => 1023, :allow_nil => true
  validates_presence_of :game_time, :if => :should_validate_game_time?
  
  def validate
     unless self.game.can_play_at?(self.date)
       errors.add_to_base game.game_dates_to_s
     end
  end
    
  def to_s
    "игра в городе #{self.city.name} #{self.date.loc}"
  end

  def get_parent
    self.game
  end
  
  def should_validate_game_time?
    self.game.tournament.time_required
  end
end
