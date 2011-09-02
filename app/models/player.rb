class Player < ActiveRecord::Base
  has_many :plays
  belongs_to :team


  validates_presence_of :firstName
  validates_presence_of :lastName
  validates_length_of :firstName, :maximum => 255
  validates_length_of :lastName, :maximum => 255

  named_scope :autocomplete, lambda { |p|
    {
      :conditions => ["\"lastName\” LIKE ?", p[:lastName].to_s + '%'],
      :order => "lastName, firstName, patronymic"
    }
  }
  
  def to_s
    "#{firstName} #{lastName}"
  end
  
end
