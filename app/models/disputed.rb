class Disputed < ActiveRecord::Base
  belongs_to :event
  validates_presence_of :question_index, :answer, :on => :create, :message => "поле не заполнено"
  validates_numericality_of :question_index, :integer_only => true, :on => :create, :message => "значение должно быть численным"
end