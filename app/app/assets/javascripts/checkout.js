$(document).on('page:change', function () {

  $('.shipping, .shipping_rates, .payment_method').select2({ minimumResultsForSearch: -1 });

  // For every submitted form in checkout
  $('.edit_order button').on('click', function () {
    $(addLoader);
  });

  // Mask for card expiry
  $('#card_expiry').mask('99/9999');

  // Switching billing and shipping addresses tabs
  $('.checkout_tabs').on('click', 'div:not(.active)', function () {
    $(this)
      .addClass('active').siblings().removeClass('active')
      .closest('div.tabs').find('div.checkout_tabs-text').removeClass('active').eq($(this).index()).addClass('active');
  });

  // "USE BILLING || Sipping ADDRESSES" logic
  if ($('#order_use_billing').is(':checked'))
    $('#shipping .address_container').hide();
  else
    $('#shipping .address_container').show();

  $('#order_use_billing').on('click', function () {
    if ($(this).is(':checked')) {
      $('#shipping .address_container').hide();
    } else {
      $('#shipping .address_container').show();
    }
  });

  // Change "PRICE OF THE ORDER" if shipping rates has been changed
  $('.delivery_item__price .delivery_item__num span').html($('.shipping_rates').find(':selected').data('rate-cost'));
  $('.shipping_rates').on('change', function () {
    var $self = $(this);

    $('.checkout_right__bottom_price').html(
      (
        parseFloat($self.data('total-without-shipping-rates')) + parseFloat($self.find(':selected').data('rate-cost'))
      ).toFixed(2)
    );

    $('.delivery_item__price .delivery_item__num span').html($self.find(':selected').data('rate-cost'));
  });

  // Hiding and switching payment methods
  ensurePaymentMethods();
  $('#order_payments_attributes__payment_method_id').on('change', function () {
    ensurePaymentMethods($(this));
  });
});

function ensurePaymentMethods(object) {
  if (!$('#order_payments_attributes__payment_method_id').length) return false;

  if (object)
    var $methodNumb = object.select2('val');
  else
    var $methodNumb = $('#order_payments_attributes__payment_method_id').select2('val');

  var $paymentMethod = $('#payment_method_' + $methodNumb);

  if ($('#order_payments_attributes__payment_method_id').find('option:selected').data('disable-submit'))
    $('.edit_order button[type="submit"]').attr('disabled', true).removeClass('red').addClass('disable');
  else
    $('.edit_order button[type="submit"]').removeAttr('disabled').removeClass('disable').addClass('red');

  $('.payment_methods_container > div')
    .hide()
    .not($paymentMethod)
    .find('select, input, textarea')
    .attr('disabled', true);

  $paymentMethod.show().find('select, input, textarea').removeAttr('disabled');
  setCookie('payment_method', $methodNumb);
}
