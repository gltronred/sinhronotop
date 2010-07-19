class Event < ActiveRecord::Base
  belongs_to :game
  belongs_to :city
  has_many :disputeds
  has_many :appeals
  has_many :results
  validates_presence_of :city_id, :moderator_name, :moderator_email, :resp_name, :resp_email, :date, :on => :create, :message => "поле не заполнено"
  #validates_format_of :moderator_email, :resp_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message => "формат email неправильный"
  def to_s
    'игра в городе ' + self.city.name + ' , ' + self.game.name + ' турнира ' + self.game.tournament.name 
  end
end
