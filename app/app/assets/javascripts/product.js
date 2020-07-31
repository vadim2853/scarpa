$(document).on('page:change', function () {
  /* play video on product page */

  $('.product .product_play-video').on('click', function () {
    $(hideAudioPlayer);

    var $parent = $(this).closest('.product');

    var $video = $('<video />', {
      controls: true,
      preload: false,
      poster: '',
    });

    $('<source />', {
      src: $parent.attr('data-video-mp4'),
      type: 'video/mp4',
    }).appendTo($video);

    $('<source />', {
      src: $parent.attr('data-video-ogg'),
      type: 'video/ogg',
    }).appendTo($video);

    $('<source />', {
      src: $parent.attr('data-video-webm'),
      type: 'video/webm',
    }).appendTo($video);

    $video.appendTo($parent.find('.product_video'));

    var $player = $parent.find('video');

    $player.get(0).play();
    $parent.find('.product_video_close').fadeIn('slow');
    $parent.find('.product_video').animate({ opacity: 1 }).fadeIn(1000);

    $video.on('ended', function () {
      $(hideVideoPlayer);
    });

    $(this).find('.play-video_icon').addClass('click');

    $('html,body').animate({ scrollTop: $('.product').offset().top }, 700);

  });

  /* close video */
  $('.product_video_close').on('click', function () {
    $(hideVideoPlayer);
  });

  /* Audio player */
  $('.product_music__block .product_music__play').on('click', function () {
    if ($(this).hasClass('play')) {
      $(hideAudioPlayer);
      $(hideVideoPlayer);
      return false;
    } else {
      $(hideAudioPlayer);
      $(hideVideoPlayer);
      $(this).addClass('play');
    }

    var $parent = $(this).closest('.product_music__block');

    var $audio = $('<audio />', {
      controls: false,
      preload: false,
      poster: '',
    });

    $('<source />', {
      src: $parent.attr('data-audio-mp3'),
      type: 'audio/mp3',
    }).appendTo($audio);

    $('<source />', {
      src: $parent.attr('data-audio-ogg'),
      type: 'audio/ogg',
    }).appendTo($audio);

    $('<source />', {
      src: $parent.attr('data-audio-wav'),
      type: 'audio/wav',
    }).appendTo($audio);

    $audio.appendTo($parent.find('.product_audio'));

    var $player = $parent.find('audio');

    $player.get(0).play();

    $audio.on('ended', function () {
      $(hideAudioPlayer);
    });
  });

  // tooltip for icons
  $('.organoleptic_icon div').focus(function () {
    $(this).tooltipster('show');
  }).blur(function () {
    $(this).tooltipster('hide');
  }).on('touch', function () {
    $(this).tooltipster('show');
  }).tooltipster({
    timer: 1000,
    theme: 'tooltipster_scarpa_icons',
  });

  $.each(['organoleptic_data', 'perfect_xp', 'technical_data'], function (_indx, val) {
    if (getCookie(val) == 'true') { $('h3[data-hook="' + val + '"]').removeClass('closed').next().show(); }

    if (getCookie(val) == 'false') { $('h3[data-hook="' + val + '"]').addClass('closed').next().hide(); }
  });

  $('.product_accordion').click(function () {
    $(this).toggleClass('closed');
    $(this).next().stop().slideToggle();

    setCookie($(this).data('hook'), !$(this).hasClass('closed'));
  });

  /* product slider */
  var $sliderArrow = $('.pslider_arrow');

  if ($sliderArrow.length) $sliderArrow.css('top', $('.pslider_bg li:first-child').position().top);

  $('.pslider_bg li').click(function () {
    var sliderText = $(this).attr('data-id');
    var $sliderImage = $('.pslider_image img[id="' + 'pslider_image_' + sliderText + '"]');
    var sliderTextPosition = $(this).position().top;

    $('.pslider_image img').fadeOut(0);
    $sliderImage.fadeIn(400);

    $sliderArrow.stop().animate({
      top: 15 + sliderTextPosition + 'px',
    }, 500);
  });

  $('select.selecter_product').select2({
    formatResult: format,
    formatSelection: format,
    minimumResultsForSearch: -1,
  });

  $('.age_selector')
    .on('change', function () {
      $(removeLoader);
      $(addLoader);

      var selectedOption = $(this).find('option:selected').val();
      var basePath = document.location.pathname;

      if (selectedOption) { basePath += '?age=' + selectedOption; }

      document.location.href = basePath;
    })
    .select2();
});

/* select */
function format(item, element) {
  return '<div class="select_product_image"><img src="' + $(item.element).data('image-url') + '" ></div>'
       + '<div class="select_product_amount">' + $(item.element).data('quantity') + '</div>'
       + '<div class="select_product_item"> ' + item.text + '</div>';
}

function hideAudioPlayer() {
  $('.product_music').find('audio').remove();
  $('.product_music').find('.play').removeClass('play');
  $('.product_music').find('.product_audio').hide(function () {
    $(this).removeClass('close');
  });
}

function hideVideoPlayer(timeout) {

  $('.product').find('.product_video_close').fadeOut('slow');
  $('.product').find('.product_video').addClass('close').fadeOut(1600);
  $('.product').find('.play-video_icon').removeClass('click');

  setTimeout(function () {
    $('.product').find('video').remove();
    $('.product').find('.product_video').fadeOut(1000, function () {
      $(this).removeClass('close');
    });
  }, 1200);

}
