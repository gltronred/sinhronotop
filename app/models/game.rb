class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events, :dependent => :delete_all
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events

  validates_presence_of :num_tours, :num_questions, :begin, :end, :submit_disp_until, :submit_appeal_until, :submit_results_until, :message => ": поле не заполнено"
  validates_numericality_of :num_tours, :num_questions, :integer_only => true, :message => ": значение должно быть численным"

  def to_s
    "этап #{self.name} турнира #{self.tournament.name}"
  end

end
