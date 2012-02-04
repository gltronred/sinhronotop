class Calculator
  DECIMAL_PLACES = 2
  
  def calc(teams, games, calc_system)
    if (calc_system.short_name == 'sl') 
      return calc_sl(teams, games)
    elsif (calc_system.short_name == 'mm') 
      return calc_mm(teams, games)
    else
      return nil
    end
  end
  
  def calculate_places(sorted_results)
    need_calc = sorted_results.detect{|r|!r.place_begin || !r.place_end}
    if need_calc
      teams_before = 0
      sorted_results.group_by{|r|-r.score}.each do |score, group|
        group.each{|r|r.place_begin = teams_before+1; r.place_end = teams_before+group.size}
        teams_before += group.size
      end
    end
    sorted_results
  end
  
  private
  
  def calc_sl(teams, games) 
    results = {}
    teams.each do |team|
      results[team.id]=TournamentResult.new(team)
    end
        
    set_duty_teams(games, teams, results)
    
    calc_percentages(teams, games, results)
                
    teams.each do |team|
      calc_worst_game(team, games, results)
      calc_average(team, games, results)
    end
    
    calculate_places(results.values.to_a.sort{|a,b| b.score <=> a.score})
  end
  
  def calc_percentages(teams, games, results)
    games.each do |game|  
      max = calc_max_result(game, teams)
      teams.each do |team|
        r_new = results[team.id].events[game.id]
        unless r_new && r_new.duty?
          r = game.result_for(team)          
          results[team.id].events[game.id] = r ? EventResult.new((r.score.to_f * 100 / max.to_f).round(DECIMAL_PLACES)) : EventResult.new(0.0, true)
        end
      end
    end
  end
  
  def set_duty_teams(games, teams, results)
    games.each do |game|  
      teams.each do |team|
        if game.city && team.city_id == game.city_id          
          results[team.id].events[game.id] = EventResult.new(0.0, false, true) 
        end
      end
    end
  end
  
  def calc_average(team, games, results)
    sum = 0.0
    count = 0
    games.each do |game|  
      result = results[team.id].events[game.id]
      if result && !result.duty? && !result.worst?
        sum += result.get_score()
        count += 1
      end
    end
    results[team.id].score = count > 0 ? (sum/count).round(DECIMAL_PLACES) : 0.0
  end
  
  def calc_worst_game(team, games, results)
    worst = nil
    games.each do |game|  
      res = results[team.id].events[game.id]
      if res.duty?
        #do nothing
      elsif res.missing?
        worst = game
        break
      elsif worst == nil || res.get_score() < results[team.id].events[worst.id].get_score()
        worst = game
      end
    end
    results[team.id].events[worst.id].set_worst() if worst
  end
  
  def calc_max_result(game, teams) 
    ret = 0
    teams.each do |team|
      result = game.result_for team
      ret = result.score.to_i if result && result.score.to_i > ret
    end
    ret
  end
end

class TournamentResult
  attr_accessor :team, :events, :score, :place_begin, :place_end
  
  def initialize(team)
    @team = team
    @events = {}
    @score = nil
    @place_begin = nil
    @place_end = nil
  end
  
  def place_to_s
    if self.place_begin && self.place_end
      self.place_begin == self.place_end ? self.place_begin : "#{self.place_begin}-#{self.place_end}"
    else
      ""
    end
  end
  
  def to_s
    "#{team}=#{score}=#{place_begin}-#{place_end}"
  end
end

class EventResult
  def initialize(score, missing = false, duty=false)
    @score = score
    @duty = duty
    @worst = false
    @missing  = missing
  end
  
  def set_duty
    @duty = true
  end

  def set_worst
    @worst = true
  end
  
  def set_missing
    @missing = true
  end
  
  def get_score
    @score
  end
  
  def missing?
    @missing
  end
  
  def duty?
    @duty
  end
  
  def worst?
    @worst
  end
  
  def to_s
    "->#{@score}#{'(d)' if duty?}#{'(w)' if worst?}#{'(m)' if missing?}"
  end
end