class Player < ActiveRecord::Base
  has_many :plays
  belongs_to :team
  

end
