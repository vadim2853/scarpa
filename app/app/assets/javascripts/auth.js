$(document).on('page:change', function () {

  $('.sing_in_button').on('click', function (e) {
    e.preventDefault();

    if (!$(this).hasClass('disabled')) {
      $(addLoader);

      $(this).addClass('disabled');

      $.ajax({
        type: 'POST',
        dataType: 'JSON',
        url: $('#login_spree_user').attr('action'),
        data: $('#login_spree_user').serialize(),
        success: function (resp) {
          Turbolinks.visit(resp.url);
        },

        error: function (resp) {
          $(removeLoader);
          $('.sing_in_button').removeClass('disabled');

          window.renderFormErrors(
            $('#login_spree_user'),
            'spree_user',
            window.isProcessableJson(resp.responseText) ? JSON.parse(resp.responseText) : resp.responseText
          );
        },
      });
    }
  });
});
