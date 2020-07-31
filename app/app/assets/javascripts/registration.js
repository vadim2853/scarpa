$(document).on('page:change', function () {

  $('.sing_up_button').on('click', function (e) {
    e.preventDefault();

    if (!$(this).hasClass('disabled')) {
      $(addLoader);

      $(this).addClass('disabled');

      $.ajax({
        type: 'POST',
        dataType: 'JSON',
        url: $('#new_spree_user').attr('action'),
        data: $('#new_spree_user').serialize(),
        success: function (resp) {
          Turbolinks.visit(resp.url);
        },

        error: function (resp) {
          $(removeLoader);
          $('.sing_up_button').removeClass('disabled');

          window.renderFormErrors(
            $('#new_spree_user'),
            'spree_user',
            window.isProcessableJson(resp.responseText) ? JSON.parse(resp.responseText) : resp.responseText
          );
        },
      });
    }
  });
});
