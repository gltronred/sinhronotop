<% if !@err_flag %>
    document.location.href="<%= event_casts_path(params[:event_id]) %>";
<% else %>
    jQuery("#mesages").html('<%= @messages_block %>');
<% end %>