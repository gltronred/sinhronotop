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
  
  def validate
     unless self.game.can_play_at?(self.date)
       message = ""
       message = message.concat "самая ранняя возможная дата игры: #{self.game.game_begin.loc}" if self.game.game_begin
       message = message.concat " самая поздняя возможная дата игры: #{self.game.game_end.loc}" if self.game.game_end
       errors.add_to_base message
     end
  end
    
  def to_s
    "игра в городе #{self.city.name} #{self.date.loc}"
  end

  def get_parent
    self.game
  end
end
