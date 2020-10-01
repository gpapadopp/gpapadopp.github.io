// Navigation active state on scroll
var nav_sections = $('section');
var main_nav = $('.nav-top');

$(window).on('scroll', function() {
    var cur_pos = $(this).scrollTop() + 10;

    nav_sections.each(function() {
        var top = $(this).offset().top,
            bottom = top + $(this).outerHeight();

        if (cur_pos >= top && cur_pos <= bottom) {
            if (cur_pos <= bottom) {
                main_nav.find('li').removeClass('active');
            }
            main_nav.find('a[href="#' + $(this).attr('id') + '"]').parent('li').addClass('active');
        }
        if (cur_pos < 200) {

            //$(".nav-top ul:first li").addClass('active');  //ΝΑ ΤΟ ΔΕΙΞΩ ΣΤΟΝ ΣΙΜΟ
            $(".nav-top ul:first li:first").addClass('active');
        }
    });
});

var img_gr = document.getElementById("img_gr");
img_gr.parent().removeClass(".sidenav img");

var img_en = document.getElementById("img_en");
img_en.parent().removeClass(".sidenav img");