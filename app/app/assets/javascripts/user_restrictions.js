$(document).on('page:change', function () {
  var country = 'IT';

  $('#popup_user_restriction').fadeIn();

  $('.close_btn .popup_close_btn').click(function () {
    $('.popup_certificate').fadeOut();
  });

  $('.country_with_flag').select2({
    placeholder: 'Select country',
    formatResult: formatState,
    formatSelection: formatState,
    escapeMarkup: function (m) { return m; },
  });

  $('.country_with_flag').on('change', function () {
    country = $(this).val();
  });

  $('.adult_true').click(function () {
    setCookie('is_adult', 'true', 7);
    setCookie('country_code', country, 7);
    $('#popup_user_restriction').fadeOut();
    Turbolinks.visit(window.location.pathname);
  });

  $('.adult_false').click(function () {
    setCookie('is_adult', 'false', 7);
    setCookie('country_code', country, 7);
    $('#popup_user_restriction').fadeOut();
  });
});

function formatState(state) {
  if (!state.id) { return state.text; }

  return '<div class="select_flag_wrapper flex"><span class="select_flag '
         + state.id.toLowerCase() + '"></span><span class="flag_text">'
         + state.text + '</span></div>';
}
