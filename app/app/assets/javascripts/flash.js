var showTime = 10000;
var fadeOutTime = 500;

$(document).on('page:change', function () {
  setTimeout(function () {
    $('.flash').slideUp(fadeOutTime);
  }, showTime);
});

window.showFlash = function (type, message) {
  $flashWrapper = $('.js-flash-wrapper');
  var $flashDiv = $('<div class="flash ' + type + '" />');

  $flashWrapper.prepend($flashDiv);
  $flashDiv.html(message).show().delay(showTime).slideUp(fadeOutTime);
};
