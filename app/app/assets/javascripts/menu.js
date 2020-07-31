$(document).on('page:fetch', function () {
  if ($('header').hasClass('open')) {
    $(closeMobileMenu);
  }
});

$(document).on('ready page:load', function () {
  $('.header_nav-mobile').on('click', function () {
    $('header').stop().toggleClass('open');

    if ($('header').hasClass('open')) {
      $('body').css({ 'padding-top': '70px', overflow: 'hidden' });
      setTimeout(function () {
        $('.bg_menu_mobile').css('display', 'block');
      }, 500);
    } else {
      $('body').css({ 'padding-top': 0, overflow: 'auto' });
      $('html, body').animate({ scrollTop: 0 }, 0);
      $('.bg_menu_mobile').css('display', 'none');
    }
  });
});

$(document).on('page:change', function (e) {

  var pathname = location.pathname;
  var page = pathname.split(/[/ ]+/).pop();
  var currentParentLink = pathname.split(page)[0];

  if (currentParentLink == '/products/' || currentParentLink == '/wine_tours/') {
    $('.nav_first a:contains("Products")').addClass('active_menu');
  }

  if (currentParentLink == '/news/' || currentParentLink == '/blogs/') {
    $('.nav_first a:contains("The Voice of Scarpa")').addClass('active_menu');
  }

  $('nav a').each(function (_ind, val) {
    if ($(val).attr('href') == pathname && $(val).attr('href') != '/coming_soon') {
      $(val).addClass('active');
    }

  });

  $('header').after('<div class="move_content"></div>');

  $('.nav_first > a').click(function () {
    e.preventDefault();
    var $parent = $(this).parent();

    if ($(window).width() <= 640) {

      $('.nav_second_mobile').removeClass('active_second_nav');
      $parent.find('.nav_second_mobile').addClass('active_second_nav');

    } else {

      if ($('.nav_second_mobile').hasClass('active_second_nav')) {
        $('.nav_second_mobile').removeClass('active_second_nav');
        $('.move_content').removeClass('margin_nav');
        setTimeout(function () {
          $parent.find('.nav_second_mobile').addClass('active_second_nav');
          $('.move_content').addClass('margin_nav');
        }, 400);
      } else {
        $parent.find('.nav_second_mobile').addClass('active_second_nav');
        $('.move_content').addClass('margin_nav');
      }
    }

  });

  if ($('.nav_second_mobile a').hasClass('active')) {
    $('.nav_second_mobile a.active').parent().addClass('active_second_nav');
    $('.nav_second_mobile a.active').parent().prev().addClass('active_menu');
    $('.move_content').addClass('margin_nav');
  }

});

function closeMobileMenu() {
  $('header').removeClass('open');
  $('body').css({ 'padding-top': 0, overflow: 'auto' });
  $('html, body').animate({ scrollTop: 0 }, 0);
  $('.bg_menu_mobile').css('display', 'none');
}
