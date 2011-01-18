class Event < ActiveRecord::Base
  belongs_to :game
  belongs_to :city
  has_many :disputeds
  has_many :appeals
  has_many :results
  belongs_to :user
    
  validates_presence_of :city_id, :moderator_name, :moderator_email, :user_id, :date, :message => ": поле не заполнено"
  validates_format_of :moderator_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message=> ": формат неверен"
    
  def to_s
    "игра в городе #{self.city.name}, #{self.game.name} турнира #{self.game.tournament.name}"
  end
  
  def modifiable?(result_type)
    eval("self.game.submit_#{result_type}_until >= Date.today()")
  end

end
