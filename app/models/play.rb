class Play < ActiveRecord::Base
  belongs_to :player
  belongs_to :team
  belongs_to :event

  named_scope :is_player_in_play, lambda { |p|
    {
      :conditions => ["player_id=? AND event_id=? AND team_id=?", p[:player_id], p[:event_id], p[:team][:id]]
    }
  }
  
  def get_rating_status
    self.status == 'captain' ? 'К' : self.team.players.detect{|p|p.id == self.player.id} ? 'Б' : 'Л'
  end
  
  def get_rating_id
  #tugarev: при экспорте НЕ ПРОСТАВЛЯТЬ ID игрокам, не входящим в базовые составы, независимо от того, выбраны они из списка или введены вручную;
    self.team.players.detect{|p|p.id == self.player.id} && self.player.rating_id && self.player.rating_id > 0 ? self.player.rating_id : ''
  end
  
  def to_s
    "#{player} сыграл в #{event} за команду #{team}"
  end

end
