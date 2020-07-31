$(document).on('page:change', function () {
  /* play video on about page */

  $('.about_item > div .about_btn-play').on('click', function () {
    var $parent = $(this).parent().parent();
    var $other = $('.about_item[data-player-started="true"]');

    if (!$other.lenght) {
      hidePlayer(1);
    }

    $parent.attr('data-player-started', 'true');

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

    $video.appendTo($parent.find('.about_video'));

    var $player = $parent.find('video');

    $parent.find('.play-icon').addClass('to-right');

    $player.get(0).play();
    $parent.find('.about_video_close').fadeIn('slow');
    $parent.find('.about_video').animate({ opacity: 1 }).fadeIn(1000);

    $parent.find('.play-text').animate({
      opacity: 0,
    }, 200);

    $video.on('ended', function () {
      $(hidePlayer);
    });
  });

  $('.about_video_close').on('click', function () {
    $(hidePlayer);
  });

  $(document).on('scroll', onScroll);

  $('.about_nav a[href^="#"]').on('click', function (e) {
    e.preventDefault();

    $(document).off('scroll');

    $('.about_nav a').each(function () {
      $(this).removeClass('active');
    });

    $(this).addClass('active');

    var target = this.hash;
    var $target = $(target);
    $('html, body').stop().animate({
      scrollTop: $target.offset().top,
    }, 500, 'swing', function () {
      window.location.hash = target;
      $(document).on('scroll', onScroll);
    });
  });
});

function hidePlayer(timeout) {
  var $other = $('.about_item[data-player-started]');

  $other.find('.about_video_close').fadeOut('slow');
  $other.find('.play-icon').removeClass('to-right');
  $other.find('.play-text').css('opacity', 1);
  $other.find('.about_video').addClass('close').fadeOut(1600);

  setTimeout(function () {
    $other.find('video').remove();
    $other.find('.about_video').fadeOut(1000, function () {
      $(this).removeClass('close');
    });
  }, 1200);

  $other.removeAttr('data-player-started');
}

function onScroll() {
  var scrollPosition = $(document).scrollTop();

  $('.about_nav a').each(function () {
    var $currentLink = $(this);
    var $refElement = $($currentLink.attr('href'));
    if ($refElement.position().top <= scrollPosition &&
      $refElement.position().top + $refElement.height() > scrollPosition) {
      $('.about_nav a').removeClass('active');
      $currentLink.addClass('active');
    } else {
      $currentLink.removeClass('active');
    }
  });
}
