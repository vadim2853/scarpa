$(document).on('page:fetch', function () {
  hideIndexPlayer(1);
});

$(document).on('ready page:load', function () {

  $('.index-item .play_index_video').on('click', function (e) {
    e.preventDefault();

    var $parent = $(this).parent();
    var $other = $('.index-item[data-player-started="true"]');

    if (!$other.lenght) {
      hideIndexPlayer(1);
    }

    $parent.attr('data-player-started', 'true');

    var $video = $('<video />', {
      controls: false,
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

    $video.appendTo($parent.find('.index_video'));

    var $player = $parent.find('video');

    $player.get(0).play();
    $parent.find('.index_video').animate({ opacity: 1 }).fadeIn(1000);

    $parent.find('.play-text').animate({
      opacity: 0,
    }, 200);

    var target = $(this).attr('target');
    var href = $(this).attr('href');
    $video.on('ended', function () {
      $(hideIndexPlayer);

      if (href !== '') {
        if (target == '_blank') {
          window.open(href, target);
        } else {
          Turbolinks.visit(href);
        }
      }
    });
  });

  $('.index_video_close').on('click', function () {
    $(hideIndexPlayer);
  });

  $('.index_items .small_item').each(function (_ind, item) {
    if ($(window).width() <= 640) {
      if (
        ($(item).prev().is('.middle_item') || $(item).prev().is('.big_item')) &&
        ($(item).next().is('.middle_item') || $(item).next().is('.big_item'))
      ) {
        $(item).css({ width: '100%', 'text-align': 'center' });
      }
    }
  });
});

function hideIndexPlayer(timeout) {
  var $other = $('.index-item[data-player-started]');

  $other.find('.index_video').fadeOut('middle', function () {
    $other.find('video').remove();
    $other.find('.index_video').fadeOut(1000, function () {
      $(this).removeClass('close');
    });
  }).addClass('close');

  $other.removeAttr('data-player-started');

}
