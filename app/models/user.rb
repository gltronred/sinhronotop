class User < ActiveRecord::Base
  has_many :tournaments
  has_many :events

  def to_s
    "#{self.name} (#{self.email})"
  end
  
  validates_presence_of :name, :password, :email, :message => "поле не заполнено"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "формат email неправильный"
  validates_length_of :password, :in => 6..10, :message => "требования к паролю: минимум 6, максимум 10 символов"
  validates_uniqueness_of :email, :message => ": этот адрес уже зарегистрирован"
    
end