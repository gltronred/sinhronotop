module PermissionHelper

  def check_permissions
    res = yield
    unless res
      flash[:error] = "У Вас недостаточно прав для этого действия или просмотра этой страницы"
      redirect_to home_path
    end
    return res
  end
  
  def check_time_constrains(item)
    res = yield
    unless res
      flash[:error] = "Невозможно из-за несоблюдения временных рамок"
      redirect_to(item)
    end
    return res
  end
  
  def is_admin?
    current_user && 'admin' == current_user.status
  end
  
  def is_registrated?
    current_user && 'znatok' != current_user.status
  end
  
  def is_resp?(event)
    (current_user && event.user == current_user) || is_org?(event.game.tournament)
  end

  def is_org?(tournament)
    current_user && (tournament.user == current_user || is_admin?)
  end

  def is_org_of_any_tournament?
    current_user && (Tournament.all.map(&:user).include?(current_user) || is_admin?)
  end
  
  def can_register?(game)
    is_registrated? && game && game.can_register?
  end

  def can_submit_disp?(event)
    event && is_resp?(event) && event.game.can_submit_disp?
  end

  def can_submit_appeal?(event)
    event && is_resp?(event) && event.game.can_submit_appeal?
  end

  def can_submit_results?(event)
    event && is_resp?(event) && event.game.can_submit_results?
  end
  
  def can_see_appeal?(game)
    game && (game.publish_appeal || is_org?(game.tournament) )
  end
 
  def can_see_disp?(game)
    game && (game.publish_disp || is_org?(game.tournament) )
  end
  
  def can_see_results?(game)
    game && (game.publish_results || is_org?(game.tournament) )
  end
end
