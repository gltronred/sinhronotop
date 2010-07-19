class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :events
  has_many :disputeds, :through => :events
  has_many :appeals, :through => :events
  has_many :results, :through => :events  
  has_and_belongs_to_many :cities
  validates_presence_of :num_tours, :num_questions, :begin, :end, :submit_disp_until, :submit_appeal_until, :submit_results_until, :on => :create, :message => "поле не заполнено"
  validates_numericality_of :num_tours, :num_questions, :integer_only => true, :on => :create, :message => "значение должно быть численным"  
  def to_s
    'игра ' + self.name + ' турнира ' + self.tournament.name 
  end
  def registrable
    self.end >= Date.today && self.begin <= Date.today
  end
  def isSubChangeable(subresource) 
    if subresource.is_a?(Disputed)
      return disp_changeable
    elsif subresource.is_a?(Appeal)
      return appeal_changeable
    elsif subresource.is_a?(Result)
      return result_changeable
    end
  end
  def disp_changeable
    self.submit_disp_until >= Date.today && self.begin <= Date.today
  end
  def appeal_changeable
    self.submit_appeal_until >= Date.today && self.begin <= Date.today
  end
  def result_changeable
    self.submit_results_until >= Date.today && self.begin <= Date.today
  end  
end
