// DO NOT REQUIRE jQuery or jQuery-ujs in this file!
// DO NOT REQUIRE TREE!

// CRITICAL that vendor-bundle must be BEFORE bootstrap-sprockets and turbolinks
// since it is exposing jQuery and jQuery-ujs

//= require vendor-bundle

// TODO: move to specific page
//= require react-vendor-bundle

//= require product-catalogue-bundle
//= require party-calculator-bundle
//= require comments-bundle

//= require common_functions
//= require turbolinks
//= require select2
//= require jquery.maskedinput
//= require Stepper
//= require swiper
//= require winery
//= require login
//= require auth
//= require registration
//= require spinner
//= require coming_soon
//= require menu
//= require product
//= require index
//= require checkout
//= require social-share-button
//= require archive_selector
//= require cabinet
//= require ga
//= require cart
//= require tour
//= require flash
//= require user_restrictions

$(document).on('page:change', function () {
  // solve probloem of iOS double tap
  $('nav a').on('touchend', function (e) {
    var $link = $(this);

    if ($link.attr('target') === '_blank') return;
    if ($link.hasClass('coming_soon_link')) return;
    if ($link.hasClass('cabinet_link')) return;

    var href = $link.attr('href');

    if (
      href === 'javascript:;' ||
      href === 'javascript:void(0)' ||
      typeof href === 'undefined' ||
      href.includes('#')
    ) return;

    e.preventDefault();

    Turbolinks.visit(href);

    return false;
  });

  /* tooltip for email if username not exist */
  if ($(window).width() <= 640 && $('.cabinet_link').attr('title')) {
    $('.cabinet_link').tooltipster({
      trigger: 'click',
      timer: 600,
      theme: 'tooltipster_scarpa',
      functionAfter: function () {
        $(addLoader);
        Turbolinks.visit($('.cabinet_link').data('href'));
      },
    });
  } else {
    $('.cabinet_link').on('click', function () {
      Turbolinks.visit($(this).data('href'));
    }).tooltipster({
      trigger: 'hover',
      timer: 1000,
      theme: 'tooltipster_scarpa',
    });
  }

  /* selecter */
  $('select.role, #credit_card, #select_tour, #select_tour_date').select2({ minimumResultsForSearch: -1 });

  /* switch language */
  $('.header_lang a').click(function (e) {
    if (DISPLAY_COMING_SOON && $(this).hasClass('coming_soon_link')) return;

    e.preventDefault();

    $(this).siblings().removeClass('active');
    $(this).addClass('active');
  });

  /* slider index */
  var swiper = new Swiper('.index_slider', {
    pagination: '.swiper-pagination',
    paginationClickable: true,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev',
    parallax: true,
    speed: 600,
    autoplay: 4000,
  });

  $('input[type="number"]').stepper();

  $('.input_number').keypress(function (e) {
    if (e.which != 8 && e.which != 0 && e.which != 46 && (e.which < 48 || e.which > 57)) {
      return false;
    }
  });

  /* checkbox shown selecter */
  var $inputCheckboxOpen = $('input#checkbox_open');
  var $labelCheckboxOpen = $('label[for="checkbox_open"]');
  var selectCheckboxOpen = $labelCheckboxOpen.parent().parent().find('.checkbox_open_select');

  $labelCheckboxOpen.on('click', function () {
    if ($inputCheckboxOpen.is(':checked') != true) {
      $(selectCheckboxOpen).slideDown(300);
    }  else {
      $(selectCheckboxOpen).slideUp(300);
    }
  });

  /* Certificate downloading */
  $(document).on('click', '.download_pdf', function () {
    var $self = $(this);

    if (!$self.hasClass('disable')) {
      $(addLoader);

      $self.addClass('disable');

      var url = $(this).data('download-path');
      var req = new XMLHttpRequest();
      req.open('GET', url.replace('_', $self.data('resultid')), true);
      req.responseType = 'blob';

      req.onload = function (event) {
        var link = document.createElement('a');
        link.href = window.URL.createObjectURL(req.response);
        link.download = 'Certificate.pdf';

        $(removeLoader);
        link.click();
        $self.removeClass('disable');
      };

      req.send();
    }
  });

  /* open popup with certificate */
  $('.cabinet_status_quizz, .quizz_list_grade').click(function () {
    $('#' + $(this).data('popupid')).fadeIn();
  });

  $('.popup_certificate .close_btn').click(function () {
    $('.popup_certificate').fadeOut();
  });
});

function scrollToCatalog() {
  $('html,body').animate({ scrollTop: $('.catalog').offset().top }, 700);
}
