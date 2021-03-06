ActionController::Routing::Routes.draw do |map|
  map.resources :longtexts
  map.resources :links

  map.home '', :controller => 'home', :action => 'index'

  map.new_error '/new_error', :controller => 'home', :action => 'new_error'
  map.create_error '/create_error', :controller => 'home', :action => 'create_error'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot    '/forgot',                    :controller => 'users',     :action => 'forgot'
  map.reset     '/reset/:reset_code',          :controller => 'users',     :action => 'reset'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.account '/account', :controller => 'users', :action => 'account'
  map.edit_password '/edit_password', :controller => 'users', :action => 'edit_password'
  map.update_password '/update_password', :controller => 'users', :action => 'update_password'

  map.resources :users

  map.resource :session

  map.resources :resultitems

  map.connect "events/:event_id/results/update_tour", :controller => 'results', :action => "update_tour"  
  map.resources :results
  map.resources :results do |r|
    r.resources :resultitems
  end
  map.show_local_teams "events/:event_id/results/show_local_teams", :controller => 'results', :action => 'show_local_teams'
  map.add_local_teams "events/:event_id/results/add_local_teams", :controller => 'results', :action => 'add_local_teams'
  
  map.duplicates "teams/duplicates", :controller => 'teams', :action => "duplicates"
  map.merge "teams/merge", :controller => 'teams', :action => "merge"
  map.resources :teams
  
  map.resources :users
  map.resources :appeals
  map.resources :disputeds

  map.resources :events
  map.resources :events do |e|
    e.resources :disputeds
    e.resources :appeals
    e.resources :results
  end
  map.change_status "events/:id/change_status", :controller => 'events', :action => "change_status"
  map.event_casts "events/:event_id/casts", :controller => 'events', :action => "casts"
  map.event_export_casts "events/:event_id/export_casts", :controller => 'events', :action => "export_casts"

  map.resources :games
  map.resources :games do |g|
    g.resources :events
    g.resources :disputeds
    g.resources :appeals
    g.resources :results
    g.resources :longtexts
    g.resources :links
  end
  map.simple_results "games/:game_id/simple_results", :controller => 'results', :action => "simple_results"
  map.appeals_and_controversial "games/:game_id/appeals_and_controversial", :controller => 'appeals', :action => "appeals_and_controversial"
  map.game_casts "games/:game_id/casts", :controller => 'games', :action => "casts"
  map.game_export_casts "games/:game_id/export_casts", :controller => 'games', :action => "export_casts"
  map.game_export_questions "games/:game_id/export_questions", :controller => 'games', :action => "export_questions"

  map.resources :cities

  map.resources :tournaments
  map.resources :tournaments do |t|
    t.resources :games
    t.resources :longtexts
    t.resources :links
  end
  map.tournament_results "tournaments/:id/results", :controller => 'tournaments', :action => "results"
  map.tournament_results_calc "tournaments/:id/results_calc", :controller => 'tournaments', :action => "results_calc"
  map.tournament_export_casts "tournament/:id/export_casts", :controller => 'tournaments', :action => "export_casts"
  map.tournament_export_questions "tournament/:id/export_questions", :controller => 'tournaments', :action => "export_questions"

  map.resources :plays
  map.resources :plays do |p|
    p.resources :events
  end
  map.event_payment "event/:id/payment", :controller => 'events', :action => "payment"  
  map.event_update_payment "event/:id/update_payment", :controller => 'events', :action => "update_payment"  

  map.set_captain "plays/set_captain/:id", :controller => 'plays', :action => "set_captain", :method => :post
  map.auto_complete "plays/auto_complete", :controller => 'plays', :action => "auto_complete", :method => :post
  
  map.root :controller => 'tournaments'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
