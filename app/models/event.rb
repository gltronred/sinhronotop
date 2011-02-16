class Event < ActiveRecord::Base
  belongs_to :game
  belongs_to :city
  has_many :disputeds, :dependent => :delete_all
  has_many :appeals, :dependent => :delete_all
  has_many :results, :dependent => :delete_all
  belongs_to :user
  belongs_to :event_status
    
  validates_presence_of :city_id, :moderator_name, :moderator_email, :user_id, :date, :message => ": поле не заполнено"
  validates_format_of :moderator_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message=> ": формат неверен"
    
  def to_s
    "игра в городе #{self.city.name} #{self.date.loc}"
  end

  def get_parent
    self.game
  end
end
