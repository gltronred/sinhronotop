authorization do
  role :admin do
    has_permission_on [:appeals, :cities, :disputeds, :events, :games, :resultitems, :results, :teams, :tournaments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guest do
    has_permission_on :results, :to => [:index]
    has_permission_on :events, :to => [:index, :show]
    has_permission_on :tournaments, :to => [:index, :show]
    has_permission_on :games, :to => [:index, :show]
  end
  
  role :resp do
    includes :guest
    has_permission_on :appeals, :to => [:index, :create, :edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :disputeds, :to => [:index, :create, :edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :results, :to => [:index, :create, :edit, :update, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :teams, :to => [:create] do
      if_attribute :user => is { user }
    end
  end
  
  role :org do
    includes :resp
  end
end