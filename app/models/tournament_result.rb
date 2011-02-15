class TournamentResult < ActiveRecord::Base
  has_one :team
  belongs_to :tournament


end