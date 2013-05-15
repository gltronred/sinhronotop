require_relative '../test_helper'
require_relative 'unit/unit_test_helper'

class CalcTest < ActiveSupport::TestCase
  
  def test_sl        
    #    g1   g2   g3   g4
    #st  duty 5    0    5
    #rb   8   duty 7    6
    #k2   1   7   duty  6
    #uu   1   x   duty  x
    #ka   2   5    x   duty

    t1,t2,t3,t4,t5 = teams(:st), teams(:rb), teams(:k2), teams(:uu), teams(:ka)    
    teams = [t1,t2,t3,t4,t5]
    games = [games(:sl1),games(:sl2),games(:sl3),games(:sl4)]
    
    c = Calculator.new()
    results = c.calc(teams, games,  calc_systems(:sl))
    
    r1,r2,r3,r4,r5 = results[0],results[1],results[2],results[3],results[4]
    
    assert_equal r1.score, 100.0
    assert_equal r1.place_begin, 1
    assert_equal r1.place_end, 2
    assert [t2,t3].include? r1.team

    assert_equal r2.score, 100.0
    assert_equal r2.place_begin, 1
    assert_equal r2.place_end, 2
    assert [t2,t3].include? r2.team

    assert_equal r3.score, 77.38
    assert_equal r3.place_begin , 3
    assert_equal r3.place_end , 3
    assert_equal r3.team, t1

    assert_equal r4.score , 48.22
    assert_equal r4.place_begin , 4
    assert_equal r4.place_end , 4
    assert_equal r4.team, t5
    
    assert_equal r5.score , 6.25
    assert_equal r5.place_begin , 5
    assert_equal r5.place_end , 5
    assert_equal r5.team, t4
    
  end
end
