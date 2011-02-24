jQuery.disable_date = function(field_id) {
    var widgets=jQuery("#"+field_id+"_1i, #"+field_id+"_2i, #"+field_id+"_3i")
    widgets.attr("value", "")
    var disable = jQuery("#"+field_id+"_dont_know").attr("checked")
    widgets.attr("disabled", disable)
};