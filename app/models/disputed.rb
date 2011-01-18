class Disputed < ActiveRecord::Base
  belongs_to :event
  
  validates_presence_of :question_index, :answer, :message => ": поле не заполнено"
  validates_numericality_of :question_index, :integer_only => true, :message => ": значение должно быть численным"
  
end