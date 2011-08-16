jQuery.disable_date = function(field_id) {
    var widgets=jQuery("#"+field_id+"_1i, #"+field_id+"_2i, #"+field_id+"_3i")
    widgets.attr("value", "")
    var disable = jQuery("#"+field_id+"_dont_know").attr("checked")
    widgets.attr("disabled", disable)
};

function select_team_from_list (value){
    if (!value){
        jQuery("#result_submit").attr('disabled', 'disabled');
    }else if(jQuery("#result_submit").attr('disabled')){
        jQuery("#result_submit").removeAttr('disabled')
    }
}

function validate_longtext(obj, max_length){
    if (obj.value.length > max_length){
        var msg = '<p class="message">Максимальная длина - '+max_length+' символов. Попробуйте разместить большой текст как несколько небольших</p>';
        jQuery("#mesages").hide();
        jQuery("#mesages").html(msg);
        jQuery("#mesages").fadeIn(700);
        jQuery("#longtext_submit").attr('disabled', 'disabled');
    }else if (jQuery("#longtext_submit").attr('disabled')){
        jQuery("#mesages").html('');
        jQuery("#longtext_submit").removeAttr('disabled');
    }
}

function show_add_player_fm(team_id){
    jQuery("#add_player_fm").hide();
    jQuery("#ac_container").hide();
    jQuery("#team_id").val(team_id);
    jQuery("#add_player_"+team_id).html(jQuery("#add_player_fm"));
    jQuery("#player_id").val('');
    jQuery("#firstName").val('');
    jQuery("#lastName").val('');
    jQuery("#patronymic").val('');

    jQuery("#add_player_fm").fadeIn(700);
    init_autocomplete();
    jQuery("#lastName").focus();

}

function set_captain(play_id, team_id){
    jQuery("#play_id").val(play_id);
    jQuery.ajax({
        type: 'POST',
        url: "/plays/set_captain/"+play_id,
        data:'id='+play_id+'&team_id='+team_id+'&event_id='+jQuery("#event_id").val(),
        success: function(){
            return false;
        }
    });
    return false;
}

function init_autocomplete(){
    jQuery( "#lastName" ).autocomplete({
        source: function( request, response ) {
             jQuery.ajax({
                type: 'POST',
                url: "/plays/auto_complete/",
                data:'lastName=' + request.term,
                dataType: "json",
                success: function( players ) {
                    response( jQuery.map( players, function( item ) {
                        var player = item.lastName + ((item.firstName != "")?" ":"") + item.firstName + ((jQuery.trim(item.patronymic) != "")?" ":"") + item.patronymic;
                        return {
                            label: player,
                            value: player,
                            player_id: item.id
                        }
                    }));

                }
            });

        },
        minLength: 2,
        select: function( event, ui ) {
            add_player_from_list(ui.item.player_id);
        },
        open: function() {
            jQuery( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jQuery( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });
}

function add_player_from_list(player_id){
    jQuery("#player_id").val(player_id);
    jQuery("#add_fm").submit();
    return false;
}