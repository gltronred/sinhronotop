class Appeal < ActiveRecord::Base
  belongs_to :event

  validates_presence_of :question_index, :goal, :argument, :message => ": поле не заполнено"
  validates_numericality_of :question_index, :integer_only => true, :message => ": значение должно быть численным"
  
  def to_s
    "Апелляция"
  end
  
  def get_parent
    self.event
  end

end
