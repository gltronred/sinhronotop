class Disputed < ActiveRecord::Base
  belongs_to :event
  
  validates_presence_of :question_index, :answer
  validates_numericality_of :question_index, :integer_only => true
  validates_length_of :answer, :maximum => 255

  def to_s
    "Спорный ответ"
  end
  
  def get_parent
    self.event
  end
  
end