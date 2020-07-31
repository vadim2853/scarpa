$(document).on('page:change', function () {

  $(document).on('click', '.header_login, .header_login_grade, .header_login_call', function (e) {
    if (DISPLAY_COMING_SOON && $(this).hasClass('coming_soon_link')) return;

    e.preventDefault();

    $(openLogin);
  });

  $('.login_menu_mobile').click(function (e) {
    if (DISPLAY_COMING_SOON && $(this).hasClass('coming_soon_link')) return;

    e.preventDefault();

    $(closeMobileMenu);

    setTimeout(function () {
      $('.login').addClass('open');
    }, 400);

    setTimeout(function () {
      $('.bg_menu_mobile').css('display', 'block');
    }, 1000);

    if ($(window).width() <= 640) {
      $('body').css('overflow', 'hidden');
    }
  });

  $('.login_close').click(function () {
    $('.login').removeClass('open').css('overflow-y', 'auto');
    $('.bg_menu_mobile').css('display', 'none');

    $('body').css('overflow', 'auto');
    $(closeReset);
  });

  $('.login_tabs').on('click', 'div:not(.active)', function () {
    $(this)
      .addClass('active').siblings().removeClass('active')
      .closest('div.tabs').find('div.login_tabs-text').removeClass('active').eq($(this).index()).addClass('active');
  });

  $('.login_forgot_password').click(function () {
    $(openReset);
  });

  $('.login_reset_cencel').click(function () {
    $(closeReset);
  });

});

function openReset() {
  $('#login_spree_user').fadeOut(100, function () {
    $('#login_reset').fadeIn(400);
  });
};

function closeReset() {
  $('#login_reset').fadeOut(100, function () {
    $('#login_spree_user').fadeIn(400);
  });
}

function openLogin() {
  $('.login').addClass('open').css('overflow-y', 'scroll');

  setTimeout(function () {
    $('body').css('overflow', 'hidden');
  }, 350);

  setTimeout(function () {
    $('.bg_menu_mobile').css('display', 'block');
  }, 600);
};
