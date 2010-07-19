class Tournament < ActiveRecord::Base
  has_many :games
  has_and_belongs_to_many :cities
  validates_presence_of :name, :org_email, :on => :create, :message => "поле не заполнено"
  #validates_format_of :org_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message => "формат email неправильный"
  
  def to_s
    'турнир ' + self.name
  end
end
