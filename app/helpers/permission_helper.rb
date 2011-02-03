module PermissionHelper

  def check_permissions
    res = yield
    unless res
      flash[:error] = "У Вас недостаточно прав для этого действия или просмотра этой страницы"
      redirect_to home_path
    end
  end
  
  def check_time_constrains(item)
    res = yield
    unless res
      flash[:error] = "Невозможно из-за несоблюдения временных рамок"
      redirect_to(item)
    end
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
 
end
