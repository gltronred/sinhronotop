class Play < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  belongs_to :event

  named_scope :is_player_in_play, lambda { |p|
    {
      :conditions => ["player_id=? AND event_id=? AND team_id=?", p[:player_id], p[:event_id], p[:team][:id]]
    }
  }

end
