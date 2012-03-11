class Tag < ActiveRecord::Base
  has_and_belongs_to_many :tournaments
  has_many :results
  def to_s
    self.name
  end
end
