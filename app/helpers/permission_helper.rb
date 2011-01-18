module PermissionHelper
  def authenticate
    if session[:user].nil?
      authenticate_or_request_with_http_basic do |email, password|
        user = User.find_by_email(email)
        if user.nil? || user.password != password
          flash[:error] = "Пользователь неизвестен"
          #redirect_to home_path
          false
        else
          session[:user] = user
          true
        end
      end
    end
  end
  
  def do_with_protection
    res = yield
    redirect_to(home_path, :notice => "У Вас недостаточно прав для этого действия или просмотра этой страницы") unless res
  end
  
  def do_event_changes(event)
    res = yield
    redirect_to(event.game, :notice => "Изменение невозможно из-за несоблюдения временных рамок") unless res
  end
  
  def is_admin?
    'admin' == session[:user].status
  end
  
  def is_registrated?
    'znatok' != session[:user].status
  end
  
  def is_resp?(event)
    user = session[:user]
    (user && event.user == user) || is_org?(event.game.tournament)
  end

  def is_org?(tournament)
    user = session[:user]
    user && (tournament.user == user || is_admin?)
  end

  def is_org_of_any_tournament?
    user = session[:user]
    user && (Tournament.all.map(&:user).include?(user) || is_admin?)
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
