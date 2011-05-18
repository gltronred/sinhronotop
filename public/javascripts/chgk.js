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
        var msg = '<p class="message">Максимальная длина - '+max_length+' символов. Попробуйте разместить большое текст как несколько небольших</p>';
        jQuery("#mesages").hide();
        jQuery("#mesages").html(msg);
        jQuery("#mesages").fadeIn(700);
        jQuery("#longtext_submit").attr('disabled', 'disabled');
    }else if (jQuery("#longtext_submit").attr('disabled')){
        jQuery("#mesages").html('');
        jQuery("#longtext_submit").removeAttr('disabled');
    }
}