class Appeal < ActiveRecord::Base
  belongs_to :event

  validates_presence_of :question_index, :goal
  validates_numericality_of :question_index, :integer_only => true
  validates_length_of :answer, :maximum => 255
  validates_length_of :argument, :maximum => 20000

  def to_s
    "Апелляция"
  end

  def get_parent
    self.event
  end

end
