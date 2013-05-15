# -*- coding: utf-8 -*-
require_relative '../test_helper'

class GameTest < ActiveSupport::TestCase
  
  def test_game_can_play_at
    game_bounded= Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15,
    :game_begin => Date.new(2011,8,8),
    :game_end => Date.new(2011,8,30) )
    assert !game_bounded.can_play_at?(Date.new(2011,8,7))
    assert game_bounded.can_play_at?(Date.new(2011,8,8))
    assert game_bounded.can_play_at?(Date.new(2011,8,21))
    assert game_bounded.can_play_at?(Date.new(2011,8,30))
    assert !game_bounded.can_play_at?(Date.new(2011,8,31))
    
    game_partly_bounded= Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15,
    :game_begin => Date.new(2011,8,8) )
    assert !game_partly_bounded.can_play_at?(Date.new(2011,8,7))
    assert game_partly_bounded.can_play_at?(Date.new(2011,8,8))
    assert game_partly_bounded.can_play_at?(Date.new(2012,8,31))
    
    game_unbounded= Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15)
    assert game_unbounded.can_play_at?(Date.new(2010,8,7))
    assert game_unbounded.can_play_at?(Date.new(2011,8,8))
    assert game_unbounded.can_play_at?(Date.new(2012,8,31))
  end
  
  def test_game_can_submit_results
    game_bounded_now = Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15,
    :submit_results_from => Date.today - 1.day,
    :submit_results_until => Date.today )
    assert game_bounded_now.can_submit_results?
    
    game_bounded_past = Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15,
    :submit_results_from => Date.today - 5.day,
    :submit_results_until => Date.today - 1.day )
    assert !game_bounded_past.can_submit_results?

    game_unbounded_now = Game.new(:tournament => tournaments(:kg),
     :name => "турнир", 
     :num_tours => 3,
     :num_questions => 15,
     :submit_results_from => Date.today - 2.day )
     assert game_unbounded_now.can_submit_results?

    game_unbounded_past = Game.new(:tournament => tournaments(:kg),
     :name => "турнир", 
     :num_tours => 3,
     :num_questions => 15,
     :submit_results_until => Date.today - 2.day )
     assert !game_unbounded_past.can_submit_results?
    
    game_unbounded_future = Game.new(:tournament => tournaments(:kg),
     :name => "турнир", 
     :num_tours => 3,
     :num_questions => 15,
     :submit_results_from => Date.today + 5.day )
     assert !game_unbounded_future.can_submit_results?
    
    game_unbounded= Game.new(:tournament => tournaments(:kg),
    :name => "турнир", 
    :num_tours => 3,
    :num_questions => 15)
    assert game_unbounded.can_submit_results?
  end

end
