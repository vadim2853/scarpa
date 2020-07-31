$(document).on('page:change', function () {
  var $loader = $('<div class="loader_bg"><div class="loader"><div class="loader_wrapp">' +
                  '<div class="spinner_border"><div class="spinner_border_inn"></div></div><div class="pie spinner">' +
                  '<div class="spinner_mask"><div class="border_border"><div class="border_inn"></div></div></div>' +
                  '</div><div class="spinner_img"></div></div></div></div>');
  $loader.appendTo('body');
});

$(document).on('page:fetch', function () {
  $(addLoader);
});

$(document).on('page:restore', function () {
  $(removeLoader);
});

function addLoader() {
  if (!$('.loader_bg').hasClass('visible')) {
    $('.loader_bg').addClass('visible');
  }
}

function removeLoader() {
  $('.loader_bg').removeClass('visible');
}
