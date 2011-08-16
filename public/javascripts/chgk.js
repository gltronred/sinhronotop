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
    jQuery("#firstName").val('');
    jQuery("#lastName").val('');
    jQuery("#patronymic").val('');

    jQuery("#add_player_fm").fadeIn(700);
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

function player_autocomplete(event){
    var lastName = jQuery.trim(jQuery("#lastName").val());
//    console.log(event.keyCode);

    switch (event.keyCode) {
        case 27 :
            jQuery("#ac_container").fadeOut(500);
            break;
        case 40 :
            if (!jQuery(".ac_li_hover").length){
              jQuery("#auto_complete_ul li").first().addClass("ac_li_hover");
            }else{
                jQuery(".ac_li_hover").removeClass("ac_li_hover").next().addClass("ac_li_hover");
            }

//            if (jQuery(".ac_li_hover").html() != null){
//                jQuery("#lastName").val(jQuery(".ac_li_hover").html());
//            }else{
//                jQuery("#lastName").val(lastName)
//            }
            break;

        case 38 :
            if (!jQuery(".ac_li_hover").length){
              jQuery("#auto_complete_ul li").last().addClass("ac_li_hover");
            }else{
                jQuery(".ac_li_hover").removeClass("ac_li_hover").prev().addClass("ac_li_hover");
            }

            break;

         case 13 :
            if (jQuery(".ac_li_hover").html() != null){
              alert("Selected Item: " + jQuery(".ac_li_hover").html());
            }
            return false;
            break;

        default : {
            if (lastName.length > 1){
               jQuery.ajax({
                    type: 'POST',
                    url: "/plays/auto_complete/",
                    data:'lastName=' + lastName,
                    dataType:'json',
                    success: function(players){
                        // generate UL with players
                        jQuery("#ac_container").html('<ul class="auto_complete_ul" id="auto_complete_ul"></ul>');

                        if (players.length > 0){
                            for (var i=0; i < players.length; i++){
                              //alert(players[i].lastName + ' ' + players[i].firstName);
                              jQuery("#auto_complete_ul").append('<li>' +
                                                                        players[i].lastName +
                                                                        ' ' + players[i].firstName +
                                                                        ' ' + players[i].patronymic +
                                                                '</li>');
                            }


                            jQuery("#auto_complete_ul li").mouseover(function(){
                                jQuery(this).addClass("ac_li_hover");
                            });
                            jQuery("#auto_complete_ul li").mouseout(function(){
                                jQuery(this).removeClass("ac_li_hover");
                            });
                            jQuery("#auto_complete_ul li").click(function(){
                                alert("Selected Item: " + jQuery(this).html());
                            });
                            jQuery("#ac_container").fadeIn(500);
                        }else{
                            jQuery("#ac_container").hide();
                        }
                    }
                });
            }else{
                jQuery("#ac_container").fadeOut(500);
            }
        }
    }



}