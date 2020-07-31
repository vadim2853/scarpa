$(document).on('page:change', function () {
  $('.add_to_cart').on('click', function (e) {
    e.preventDefault();

    var $self = $(this);
    var form = $self.parents('form');

    if (!$self.hasClass('click-action')) {

      $self.addClass('click-action');

      $.ajax({
        type: 'POST',
        dataType: 'TEXT',
        url: form.attr('action'),
        data: form.serialize(),
        success: function (cartLinkContent) {
          $(removeLoader);
          $self.removeClass('click-action');

          var parent = '';
          if ($('.header_location').find('.cabinet_link').length != 0)
            parent = '.cabinet_link';
          else
            parent = '.header_login';

          if ($('.header_location ' + parent).next().hasClass('header_amount')) {
            $('.header_location .header_amount').replaceWith(cartLinkContent);
          } else {
            $(cartLinkContent).insertAfter('.header_location ' + parent);
          }

          if (typeof (updateQuantities) === typeof (Function)) {
            updateQuantities($('#select_tour_date'), $('#s2id_select_tour_date .select2-chosen').text());
          }
        },

        error: function (error) {
          $(removeLoader);
          $self.removeClass('click-action');

          alert(error);
        },
      });
    }
  });

  if ($('form#update-cart').is('*')) {
    $('form#update-cart a.delete').unbind('click').on('click', function () {
      var $self = $(this);

      if (!$self.hasClass('disabled')) {
        $(addLoader);

        $(this).parent().animate({
          opacity: 0,
        }, 300).slideUp(400, function () {
          $(this).remove();
        });

        $('.delete').addClass('disabled');
        $self.parent('.checkout_item').find('input.line_item_quantity').val(0);
        $self.parents('form').first().submit();
      }
    });
  }

  /* order history */
  $('.order_hist__name_mobile').click(function () {
    $('.list_of_orders').toggleClass('open');

    if ($('.list_of_orders').hasClass('open')) {
      $('body').addClass('order_open');
    } else {
      $('body').removeClass('order_open');
    }
  });
});
