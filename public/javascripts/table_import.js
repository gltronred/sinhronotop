$.noConflict();
jQuery(document).ready(function($) {
    //select all the a tag with name equal to modal
    $('a[name=modal]').click(function(e) {
        //Cancel the link behavior
        e.preventDefault();

        //Get the A tag
        var id = $(this).attr('href');

        var excel_input = $("#excel_input")
        excel_input.val("")
        excel_input.attr("num_questions", $(this).attr('num_questions'))
        excel_input.attr("teams", $(this).attr('teams'))
        excel_input.attr("tour", $(this).attr('tour'))

        //Get the screen height and width
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();

        //Set heigth and width to mask to fill up the whole screen
        $('#mask').css({
            'width': maskWidth,
            'height': maskHeight
        });

        //transition effect		
        $('#mask').fadeIn(1000);
        $('#mask').fadeTo("slow", 0.8);

        //Get the window height and width
        var winH = $(window).height();
        var winW = $(window).width();

        //Set the popup window to center
        $(id).css('top', winH / 2 - $(id).height() / 2);
        $(id).css('left', winW / 2 - $(id).width() / 2);

        //transition effect
        $(id).fadeIn(2000);

    });

    //if close button is clicked
    $('.window .close').click(function(e) {
        //Cancel the link behavior
        e.preventDefault();

        $('#mask').hide();
        $('.window').hide();
    });

    //if close button is clicked
    $('.window .import').click(function(e) {
        //Cancel the link behavior
        e.preventDefault();
        $.do_excel_import()

        $('#mask').hide();
        $('.window').hide();
    });

    //if mask is clicked
    $('#mask').click(function() {
        $(this).hide();
        $('.window').hide();
    });
    
    $('#how_to_import_link').click(function() {
        $('#how_to_import_ul').toggle();
    });
    $('#add_new_team_link').click(function() {
        $('#add_new_team_form').toggle();
    });
    $('#add_listed_team_link').click(function() {
        $('#add_listed_team_form').toggle();
    });
});

jQuery.do_excel_import = function() {
    var excel_input = jQuery("#excel_input")
    var teams = excel_input.attr('teams').split(",")
    var text = excel_input.val()
    var tour = excel_input.attr("tour")
    var num_questions = excel_input.attr("num_questions")
    var lines = text.replace(/\s+$/g, "").split("\n")
    for (var l = 0; l < lines.length; l++) {
        var scores = lines[l].split(/\t/gi)
        for (var s = 0; s < scores.length; s++) {
            var checkbox_id = "#team" + teams[l] + "_tour" + tour + "_question" + (num_questions * (tour - 1) + s + 1)
            var new_value = (scores[s] == "1" || scores[s] == "+")
            checkbox = jQuery(checkbox_id)
            var existing_value = checkbox.attr('checked')
            if (new_value != existing_value) {
                checkbox.click()
            }
        }
    }
};
