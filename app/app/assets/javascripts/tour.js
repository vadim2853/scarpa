$(document).on('page:change', function () {
  $('.tour_accordion').click(function () {
    $(this).toggleClass('closed');
    $(this).next().stop().slideToggle();

    setCookie($(this).data('hook'), !$(this).hasClass('closed'));
  });

  var tourSlides  = ($(document).width() <= 640) ? 1 : 3;

  var swiper = new Swiper('.swiper-tour', {
    slidesPerView: tourSlides,
    paginationClickable: true,
    nextButton: '.slider_tour_next',
    prevButton: '.slider_tour_prev',
    pagination: '.swiper-pagination',
    paginationType: 'progress',
    autoplay: 5000,
  });

  $('#select_tour').on('change', function (evt) {
    $ul = $('#inclusions');
    payload = $('option[value="' + evt.val + '"]').data();

    $('#price').html(payload.price);

    $ul.html('');

    payload.inclusions.forEach(function (text) {
      $ul.append($('<li>', { text: text }));
    });
  });

  var $selectTourDate = $('#select_tour_date');

  $selectTourDate.on('change', function (evt) {
    updateQuantities($selectTourDate, evt.val);
  });
});

function setValue(selector, value) {
  selector.val(value);
  selector.attr('value', value);
}

function updateQuantities(selector, dateTime) {
  if (!selector.length) return false;
  var url = selector.data().url.replace('date_time', encodeURIComponent(dateTime));

  addLoader();

  $.get(url)
    .done(function (data) {
      var $quantityInput = $('#order_quantity');
      var min = $quantityInput.attr('min');

      var $newQuantityInput = $('<input>', {
        id: 'order_quantity',
        min: min,
        max: $quantityInput.attr('max'),
        value: $quantityInput.attr('value'),
        type: 'number',
        name: 'order[quantity]',
        class: 'input_number',
        pattern: '[0-9]*',
      });

      if (data.count) {
        var val = $quantityInput.val();

        if (val < min) {
          setValue($newQuantityInput, min);
        } else if (val > data.count) {
          setValue($newQuantityInput, data.count);
        }

        $newQuantityInput.attr('max', data.count);
      } else {
        setValue($newQuantityInput, 0);
        $newQuantityInput.attr('disabled', true);
      }

      $('.stepper').replaceWith($newQuantityInput);
      $('input[type="number"]').stepper();
      $('#leftover').html(data.count);
    })

    .always(function () {
      removeLoader();
    });
}
