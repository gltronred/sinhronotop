require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def test_merge
    real = Team.find(:first, :conditions => "name = 'Против ветра' and teams.rating_id > 0")
    real_players_old, real_plays_old, real_results_old = real.players.size, real.plays.size, real.results.size
    duplicate = Team.find(:first, :conditions => "name = 'Против ветра ложная' and teams.rating_id is null")

    Team.merge(real, duplicate)

    real_new = Team.find(:first, :conditions => "name = 'Против ветра' and teams.rating_id > 0")
    duplicate_new = Team.find(:first, :conditions => "name = 'Против ветра ложная' and teams.rating_id is null")

    assert_nil duplicate_new
    assert real_new
    assert_equal 4, real_new.players.size - real_players_old
    assert_equal 6, real_new.plays.size - real_plays_old
    assert_equal 1, real_new.results.size - real_results_old    
  end
end
