module PermissionHelper

  def do_with_protection
    res = yield
    unless res
      flash[:error] = "У Вас недостаточно прав для этого действия или просмотра этой страницы"
      redirect_to home_path
    end
    #redirect_to(home_path, :error => "У Вас недостаточно прав для этого действия или просмотра этой страницы") unless res
  end
  
  def do_event_changes(event)
    res = yield
    unless res
      flash[:error] = "Невозможно из-за несоблюдения временных рамок"
      redirect_to(event.game)
    end
    #redirect_to(event.game, :error => "Изменение невозможно из-за несоблюдения временных рамок") unless res
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

  def modify_event_results?(event, result_type, do_protect=false)
    res = resp?(event) && event.modifiable?(result_type)
    handle_permission_result(res, do_protect)
  end

  private

  def validate_update_by_date(subresource)
    @game = Event.find(subresource.event_id).game
    if !@game.is_sub_changeable(subresource)
      render :action => "common/expired"
    end
  end
end
