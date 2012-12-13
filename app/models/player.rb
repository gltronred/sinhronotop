class Player < ActiveRecord::Base
  has_many :plays
  belongs_to :team


  validates_presence_of :firstName
  validates_presence_of :lastName
  validates_length_of :firstName, :maximum => 255
  validates_length_of :lastName, :maximum => 255

  named_scope :autocomplete, lambda { |p|
    {
      :conditions => ["\"lastName\" LIKE ?", p[:lastName].to_s + '%'],
      #:joins => :team,
      :order => "\"lastName\", \"firstName\", \"patronymic\""
    }
  }
  
  def get_rating_status(team)
    self.team && self.team.id == team.id ? 'Б' : 'Л'
  end
  
  def to_s
    "#{lastName} #{firstName} #{patronymic if patronymic} #{self.team ? "(#{self.team.to_s})" : '(без команды)'}"
  end
  
end
