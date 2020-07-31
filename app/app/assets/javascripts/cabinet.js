$(document).on('page:change', function () {
  $('body').addClass('cabinet_wrapper');

  $(
    'select.language, select.timezone, select.country, '
    + '.region, .selecter_month, .selecter_data'
  ).select2({ minimumResultsForSearch: -1 });

  if ($(window).width() <= 640) {

    var timeHistory = 500;
    var timeSettings = 1300;

    /*
     * Order history mobile animation
     */
    $('.cabinet_history_tab__mobile').click(function () {
      $(this).toggleClass('open');
      $('.cabinet_history').slideToggle(timeHistory);

      if ($(this).hasClass('open')) {
        $('body').css('overflow', 'hidden');
        $('.cabinet_history').css('opacity', 1);
        $('body,html').animate({
          scrollTop: 0,
        }, 400);
      } else {
        $('body').css('overflow', 'auto');
        setTimeout(function () {
          $('.cabinet_history').css('opacity', 0);
        }, timeHistory);
      }
    });

    /* settings mobile animation */
    if ($('.cabinet') && $('.cabinet').data('page') == document.location.pathname) {
      setTimeout(function () {
        $('body, html').animate({
          scrollTop: $('.cabinet_right_side').outerHeight() + $('.head-m').outerHeight(),
        }, 1000);
      }, 1000);
    }

  } else {

    $('.cabinet_settings').click(function () {
      $('.cabinet_settings_wrapp').fadeIn(300);
      $('.cabinet_history, .cabinet_history_date').fadeOut(0);
    });

  }

  /*
   * Region (state) loader
   */
  $('.country').on('change', function () { updateRegion($(this).parents('.address_container')); });

  /*
   * User info form
   */
  $('#user_info_form').submit(function () {
    if (!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $(addLoader);

      $('#picture').attr('disabled', true);
      return true;
    }

    return false;
  }).on('ajax:complete', function (e, data, status) {
      if (status === 'success') { $('.cabinet_right_side').html(data.responseText); }

      setTimeout(function () {
        $('.cabinet_wrapper form').removeClass('disabled');
        $('#picture').removeAttr('disabled');
        $(removeLoader);
      }, 1000);
    });

  /*
   * Password changing form
   */
  $('#password_changing').submit(function () {
    if (!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');
      $(addLoader);

      $('#picture').attr('disabled', true);
      return true;
    }

    return false;
  }).on('ajax:success', function () {
    $(removeLoader);
    $(this).removeClass('disabled');
    $('#picture').removeAttr('disabled');
    $('#password_changing input').val('');

    window.clearFormErrors($(this));
    alert('Password has been changed successfully!');

  }).on('ajax:error', function (e, xhr, status, error) {
    $(removeLoader);
    $(this).removeClass('disabled');
    $('#picture').removeAttr('disabled');

    window.renderFormErrors(
      $(this),
      'user',
      window.isProcessableJson(xhr.responseText) ? JSON.parse(xhr.responseText) : xhr.responseText
    );
  });

  /*
   * Select image button
  */
  $('.select_image_button').on('click', function () {
    $('.cabinet_upload_image input').trigger('click');
  });

  /*
   * Image listener
  */
  $('.cabinet_upload_image input').on('change', function () {
    if (window.FileReader && window.File && window.FileList && window.Blob) {
      if (this.files && this.files[0]) {
        $('.cabinet_upload_profile').hide();
        var reader = new FileReader();
        reader.onload = function (e) { $('.cabinet_upload_image img').attr('src', e.target.result); };

        reader.readAsDataURL(this.files[0]);
      }
    } else {
      alert('Your browser not supported! Please, try another browser.');
    }
  });

  /*
   * Upload image button
  */
  $('.upload_image_button').on('click', function () {
    var $this = $(this);

    if (!$this.hasClass('disabled')) {
      var $imageInput = $('.cabinet_upload_image input[type="file"]');

      if ($imageInput.val()) {
        $this.addClass('disabled');
        var formData = new FormData();
        formData.append('image', $imageInput[0].files[0]);

        $.ajax({
          url: $('.cabinet_upload_image').data('avatar-upload-path'),
          type: 'POST',
          dataType: 'HTML',
          data: formData,
          contentType: false,
          cache: false,
          processData:false,
          beforeSend: function () {
            $(addLoader);
          },

          success: function (data, status) {
            if (status === 'success') { $('.cabinet_right_side').html(data); }

            $(removeLoader);
            $this.removeClass('disabled');
            $imageInput.val('');
          },

          error: function () {
            $(removeLoader);
            $this.removeClass('disabled');
            $imageInput.val('');

            alert('Error occurred! Please, try again or refresh your page.');
          },
        });
      }
    }
  });

  /*
   * Switching orders by year
  */
  $('.cabinet_history_date #year').on('change', function () {
    if (!$('.cabinet_history_date').hasClass('disabled')) {
      $(addLoader);
      $('.cabinet_history_date').addClass('disabled');

      Turbolinks.visit(document.location.pathname + '?year=' + $(this).find('option:selected').val());
    }
  });

  /*
   * Switching orders by year and month
  */
  $('.cabinet_history_date #month').on('change', function () {
    if (!$('.cabinet_history_date').hasClass('disabled')) {
      $(addLoader);
      $('.cabinet_history_date').addClass('disabled');

      Turbolinks.visit(
        document.location.pathname + '?year=' + $('.cabinet_history_date #year').find('option:selected').val() +
        '&month=' + $(this).find('option:selected').val()
      );
    }
  });

  /*
   * tracking
  */
  $('html').click(function () {
    $('.tracking_name').removeClass('track_open');
    $('.tracking_name').next().slideUp(200);

    $(arrowTrack);
  });

  $('.tracking-container').click(function (event) {
    event.stopPropagation();
  });

  $('.tracking_name').click(function () {
    $('.tracking_name').toggleClass('track_open');
    $(this).next().slideToggle(200);

    $(arrowTrack);
  });
});

function arrowTrack() {
  if ($('.tracking_name').hasClass('track_open')) {
    $('.tracking_name .arrow_black').addClass('open');
  } else {
    $('.tracking_name .arrow_black').removeClass('open');
  }
}

var updateRegion = function (namespace) {
  'use strict';

  var $country = namespace.find('.country').select2('val');
  var $stateSelect = namespace.find('select.region');
  var $stateInput = namespace.find('input.state_name');

  $stateSelect.select2('disable');

  $.get(namespace.find('select.country').data('states-search') + '?country_id=' + $country, function (data) {
    var states = data.states;
    if (states.length > 0) {
      $stateSelect.html('');
      var statesWithBlank = [
        { name: '', id: '', },
      ].concat(states);

      $.each(statesWithBlank, function (pos, state) {
        $('<option />', {
          value: state.id,
          text: state.name,
        }).appendTo($stateSelect);
      });

      $stateSelect.prop('disabled', false).show().select2({ minimumResultsForSearch: -1 });
      $stateInput.hide().prop('disabled', true);

    } else {
      $stateInput.prop('disabled', false).show();
      $stateSelect.select2('destroy').hide();
    }
  });
};
