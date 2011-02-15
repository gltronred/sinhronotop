class CalcSystem < ActiveRecord::Base
  has_many :tournaments
  
  def to_s
    self.name
  end
end