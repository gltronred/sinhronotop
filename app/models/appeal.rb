class Appeal < ActiveRecord::Base
  validates_presence_of :question_index, :goal, :on => :create, :message => "поле не заполнено"
  validates_numericality_of :question_index, :integer_only => true, :on => :create, :message => "значение должно быть численным"
  belongs_to :event
end
