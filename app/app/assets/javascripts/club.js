//= require contacts/theme

$(document).on('page:change', function () {

  $('.type_event div').click(function () {
    $(this).closest('.type_event').find('div').removeClass('active');
    $(this).addClass('active');
  });

  initMapClub();

});

function initMapClub() {

  var map = new google.maps.Map(document.getElementById('club_map'), {
    disableDefaultUI: true,
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT,
    },
    rotateControl: true,
    scrollwheel: false,
    center: { lat: 42.5294601, lng: 14.0335121 },
    zoom: 7,
  });

  map.set('styles', scarpaTheme);
}
