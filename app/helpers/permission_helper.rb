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

  def resp?(event, do_protect=false)
    res = (session[:user] && event.resp_email == session[:user].email) || org?(event.game.tournament, false)
    handle_permission_result(res, do_protect)
  end

  def org?(tournament, do_protect=false)
    res = (session[:user] && tournament.org_email == session[:user].email) || admin?(false)
    handle_permission_result(res, do_protect)
  end

  def admin?(do_protect=false)
    res = session[:user] && 'admin' == session[:user].role
    handle_permission_result(res, do_protect)
  end

  def modify_event_results?(event, result_type, do_protect=false)
    res = resp?(event) && event.modifiable?(result_type)
    handle_permission_result(res, do_protect)
  end
  
  def check_admin
    admin?(true)
  end
  
  private

  def handle_permission_result(res, do_protect)
    if !res && do_protect
      do_no_permisstion
    else
      res
    end
  end

  def do_no_permisstion
    redirect_to(home_path, :notice => "У Вас недостаточно прав для этого действия или просмотра этой страницы")
  end

  def validate_update_by_date(subresource)
    @game = Event.find(subresource.event_id).game
    if !@game.is_sub_changeable(subresource)
      render :action => "common/expired"
    end
  end
end
