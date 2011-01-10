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

  def check_see(event_or_game, result_type)
    game = case event_or_game
    when Event
      event_or_game.game
    when Game
      event_or_game
    end
    do_no_permisstion unless eval('game.submit_'<<result_type<<'_until < Date.today()')
  end

  def check_modify(event, result_type)
    unless admin? || session[:user].email == event.game.tournament.org_email || (session[:user].email == event.pesp_email && eval('event.game.submit_'<<result_type<<'_until >= Date.today()'))
      do_no_permisstion
    end
  end

  def admin?
    user = session[:user]
    user && 'admin' === user.role
  end

  def check_modify_game(game)
    do_no_permisstion unless admin? || game.tournament.org_email == session[:user].email
  end

  def check_modify_tournament(tournament)
    do_no_permisstion unless admin? || tournament.org_email == session[:user].email
  end

  def check_admin
    do_no_permisstion unless admin?
  end

  def do_no_permisstion
    flash[:error] = "У Вас недостаточно прав для этого действия / просмотра этой страницы"
    #redirect_to home_path
  end

  def check_modify_event(event)
    unless admin? || session[:user].email === [event.game.tournament.org_email, event.pesp_email]
      do_no_permisstion
    end
  end
  def validate_update_by_date(subresource)
    @game = Event.find(subresource.event_id).game
    if !@game.is_sub_changeable(subresource)
      render :action => "../common/expired"
    end
  end
end
