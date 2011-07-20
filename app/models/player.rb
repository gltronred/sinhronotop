class Player < ActiveRecord::Base
  has_many :plays
  belongs_to :team


  validates_presence_of :firstName, :message => "Имя не может быть пустым."
  validates_presence_of :lastName, :message => "Фамилия не может быть пустой."
  validates_length_of :firstName, :maximum => 255
  validates_length_of :lastName, :maximum => 255
end
