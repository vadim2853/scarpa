var selectedMarker;

function enableBounceOfSelectedMarker() {
  selectedMarker.setAnimation(google.maps.Animation.BOUNCE);
}

function disableBounceOfSelectedMarker() {
  if (selectedMarker) {
    selectedMarker.setAnimation(null);
    selectedMarker = null;
  }
}

function getDetailsOfSelectedMarker(marker, callback) {
  var path = decodeURIComponent($currentScript.data('place-details-path')).trim();

  $.ajax({
    type: 'get',
    dataType: 'json',
    url: path + marker.get('id'),
    success: function (resp) { callback(resp); },

    error: function () {
      alert('Unexpected error of loading data! Please, try again.');
    },
  });
}

// jscs:disable requireCamelCaseOrUpperCaseIdentifiers
function showInfoPanel(marker) {
  $(addLoader);

  var $iPanel = $('.info_panel');

  getDetailsOfSelectedMarker(marker, function (params) {
    $('.time_box .time').hide();
    $('.leave_comment_button').removeAttr('href').hide();

    $iPanel.find('.img_box img').attr({ src: params.image });
    $iPanel.find('.title').html(params.name);
    $iPanel.find('.description').html(params.description);
    $iPanel.find('.stars_box').removeAttr('class').addClass('stars_box star_number_' + params.rating);
    $iPanel.find('.address').html(params.address);
    $iPanel.find('.time_box .time').html(params.work_time);

    if (params.review_link) {
      $iPanel.find('.leave_comment_button').attr({ href: params.review_link, }).css({ display: 'block', });
    }

    $(removeLoader);

    if ($(window).width() >= 1366) {
      $iPanel.animate({ left: 0, width: '20%' }, { duration: 500, queue: false });
      $('#map').animate({ width: '80%' }, { duration: 500, queue: false });
    }

    if ($(window).width() <= 1366 && $(window).width() >= 740) {
      $iPanel.animate({ left: 0, width: '30%' }, { duration: 500, queue: false });
      $('#map').animate({ width: '70%' }, { duration: 500, queue: false });
    }

    if ($(window).width() <= 740) {
      $iPanel.animate({ left: 0, width: '100%' }, { duration: 500, queue: false });
      $('html,body').animate({ scrollTop: $iPanel.offset().top }, 700);
      $iPanel.find('.fade_container').delay(100).fadeIn('fast');
    }

    $iPanel.find('.fade_container').delay(500).fadeIn('middle');
    setTimeout(function () { google.maps.event.trigger(map, 'resize'); }, 1000);
  });
}

function hideInfoPanel() {
  $('.fade_container').fadeOut(500, function () {
    $('.info_panel').animate({ left: -500, width: '0' }, { duration: 500, queue: false });
    $('#map').animate({ width: '100%' }, { duration: 500, queue: false });
    setTimeout(function () { google.maps.event.trigger(map, 'resize'); }, 500);
  });
}
