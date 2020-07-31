//= require jquery-ui
//= require jquery.ui.touch-punch.dk

var arrScripts = document.getElementsByTagName('script');
var $currentScript = $(arrScripts[arrScripts.length - 1]);
var props = $currentScript.data('props');
var gradeState = {
  currentQuestion: null,
  currentQuestionIndex: 0,
  maxQuestionIndex: 0,
};

$(document).on('page:change', function () {
  clearSessions();
  gradeState.maxQuestionIndex = props.questions.length - 1;
  initOrLoadGradeQuestionIndex();
  loadCurrentQuestion();

  /*
   * Breadcrumbs page name
   */
  $('.current_grade').html(props.literal_name); // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers

  /*
   * Process form
   */
  $('.grade_container button').on('click', function () {
    if (!$(this).hasClass('disabled')) {
      $(this).addClass('disabled');

      sendAnswer(function (resp) {
        loadNextQuestionOrFinalize(resp);
      });
    }
  });

  /*
   * Retake grade
   */
  $('.retake_grade').on('click', function () {
    clearSessions();
    updateGradeQuestionIndex(0);
    loadCurrentQuestion();

    $('.final_display').fadeOut('fast', function () {
      $('.grade_container').fadeIn('fast');
    });
  });

  /*
   * Emulate single selection
   */
  $(document).on('click', '.grade_container input[type="radio"]', function () {
    $(this).parents('.variants').find('input[type="radio"]').not(this).attr({ checked: false });
  });
});

function clearSessions() {
  $.ajax({
    type: 'post',
    url: props.clear_grade_session_path, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
}

function initOrLoadGradeQuestionIndex() {
  var storedQuestionIndex = getCookie('currentQuestionIndex');

  if (storedQuestionIndex != '')
    gradeState.currentQuestionIndex = parseInt(storedQuestionIndex);
  else
    updateGradeQuestionIndex(0);
}

function updateGradeQuestionIndex(index) {
  gradeState.currentQuestionIndex = index;
  setCookie('currentQuestionIndex', gradeState.currentQuestionIndex, 1);
}

function loadCurrentQuestion() {
  gradeState.currentQuestion = props.questions[gradeState.currentQuestionIndex];
  var questionNumber    = gradeState.currentQuestionIndex + 1;

  $('.grade_container .quizz_counter').html(questionNumber + ' / ' + props.questions.length);
  $('.grade_container .title').html(gradeState.currentQuestion.title);
  $('.grade_container .variants .quizz_block').html('');

  switch (gradeState.currentQuestion.variantsType) {
    case 'v_choose_one':
      renderChooseOneVariantsType(gradeState.currentQuestion.variants);
      break;
    case 'v_match':
      renderMatchVariantsType(gradeState.currentQuestion.variants);
      break;
    case 'v_reorder':
      renderReorderVariantsType(gradeState.currentQuestion.variants);
      break;
  }
}

function renderChooseOneVariantsType(variants) {
  var formTags = [];
  $.each(variants, function (ind, val) {
    formTags.push(
      '<div class="quizz_radio">',
        '<input type="hidden" name="variants[' + ind + '][title]" value="' + escapeHtml(val.title) + '">',
        '<input type="radio" id="variant_', ind, '" name="variants[' + ind + '][right]" class="radio_input">',
        '<label for="variant_', ind, '">', val.title, '</label>',
      '</div>'
    );
  });

  $('.grade_container .variants .quizz_block')
    .append(formTags.join(''))
    .removeClass('flex')
    .addClass('quizz_inline');

  $('.grade_container .variants input[type="radio"]:first').attr('checked', true);
}

function renderMatchVariantsType(variants) {
  $('.grade_container .variants .quizz_block')
    .addClass('flex')
    .removeClass('quizz_inline')
    .append('<div class="quizz_drag_drop q_left_side"></div><div class="quizz_number"></div>' +
      '<div class="quizz_drag_drop q_right_side"></div>');

  var leftFormTags  = [];
  var rightFormTags = [];
  var separators    = [];

  // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
  $.each(variants, function (_ind, val) {
    var uniqId = Math.random().toString(36).substr(2, 9);

    if (val.to_match == 'false') {
      separators.push('<div>-</div>');
      leftFormTags.push(
        '<div class="quizz_drop">',
          '<div>', val.title, '</div>',
          '<input class="m_id" type="hidden" ' +
                  'name="variants[' + uniqId + '][match_id]"' +
                  'value="' + val.match_id + '">',
        '</div>'
      );
    } else {
      rightFormTags.push(
        '<div class="quizz_drop">',
          '<div>', val.title, '</div>',
          '<input class="m_id"' +
                  'type="hidden" ' +
                  'name="variants[' + uniqId + '][match_id]" ' +
                  'value="' + val.match_id + '">',
        '</div>'
      );
    }
  });

  // jscs:enable requireCamelCaseOrUpperCaseIdentifiers

  $('.grade_container .variants .q_left_side').append(leftFormTags.join(''));
  $('.grade_container .variants .quizz_number').append(separators.join(''));
  $('.grade_container .variants .q_right_side').append(rightFormTags.join(''));
  $('.quizz_drag_drop').sortable();
}

function renderReorderVariantsType(variants) {
  var formTags = [];
  var quizzNumberTags = [];

  $('.grade_container .variants .quizz_block').append(
    '<div class="quizz_number"></div><div class="quizz_drag_drop"></div>'
  );

  $.each(variants, function (ind, val) {
    quizzNumberTags.push('<div>', ind + 1, '</div>');

    formTags.push(
      '<div class="quizz_drop">',
        '<div>', val.title, '</div>',
        '<input type="hidden" name="variants[' + ind + '][title]" value="' + escapeHtml(val.title) + '">',
      '</div>'
    );
  });

  $('.grade_container .quizz_block').addClass('flex').removeClass('quizz_inline');
  $('.grade_container .quizz_block .quizz_number').append(quizzNumberTags.join(''));
  $('.grade_container .quizz_block .quizz_drag_drop').append(formTags.join(''));
  $('.quizz_drag_drop').sortable();
}

function loadNextQuestionOrFinalize(response) {
  var nextQuestionIndex = gradeState.currentQuestionIndex + 1;

  updateGradeQuestionIndex(nextQuestionIndex);
  if (nextQuestionIndex > gradeState.maxQuestionIndex) {
    destroyCookie('currentQuestionIndex');
    showFinalDisplay(response);
  } else {
    loadCurrentQuestion();
  }
}

function showFinalDisplay(response) {
  // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
  var percentage = response.percent + ' points of ' + props.literal_name;

  if (response.score < props.nomination_minimum) {
    $('.final_display .percentage').hide();

    $('.final_display .quizz_points').html(response.percent + ' points').show();
    $('.retake_grade').addClass('red').removeClass('white_red');
    $('.final_display .quizz_min_poins')
      .html('minimum ' + props.nomination_minimum + ' right answers to pass')
      .show();
  } else {
    $('.final_display .quizz_points').hide();
    $('.final_display .quizz_min_poins').hide();

    $('.final_display .percentage').html(percentage).show();
    $('.retake_grade').addClass('white_red').removeClass('red');
  }

  if (response.resultId && response.score >= props.nomination_minimum) {
    $('.download_pdf').attr('data-resultid', response.resultId).addClass('red').removeClass('disable');

  } else if (response.resultId && response.score < props.nomination_minimum) {
    $('.download_pdf').addClass('disable').removeClass('red');

  } else if (!response.resultId) {

    $('.try_to_login').show();
    $('.download_pdf')
      .addClass('red disable header_login_grade')
      .removeClass('disable download_pdf')
      .html('Sign in/up');
  }

  if (!props.is_last_grade && response.percent >= props.passing_score) {
    $('.next_level_btn').css('display', 'inline-block');
  } else {
    $('.next_level_btn').css('display', 'none');
  }

  $('.final_display .congrats_or_not').html(response.congratsOrNot);
  $('.final_display .grade_name').html('“' + props.grade.title + '”');
  $('.final_display .nomination_icon').html(['<img src="', response.nominationIcon, '">'].join(''));

  $('.grade_container').fadeOut('fast', function () {
    $('.final_display').fadeIn('fast');
  });

  var shareUrl = document.location.origin +
                  props.certificate_path.replace('_', response.resultId) +
                  '?v=' + Math.round(new Date().getTime());

  $('.social-share-button').attr({
    'data-url': shareUrl,
  });
}

// jscs:enable requireCamelCaseOrUpperCaseIdentifiers

function sendAnswer(callback) {
  $(addLoader);

  $.ajax({
    type: 'patch',
    data: JSON.stringify(prepareAnswer()),
    contentType: 'application/json',
    url: props.update_user_score_path, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
    success: function (resp) {
      $(removeLoader);
      $('.grade_container button').removeClass('disabled');

      typeof callback === 'function' && callback(resp);
    },

    error: function () {
      $(removeLoader);
      $('.grade_container button').removeClass('disabled');

      alert('Error occurred! Please, refresh page and try again!');
    },
  });
}

function prepareAnswer() {
  var result = {
    answers: [],
    question_id: gradeState.currentQuestion.id, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
    finalize: gradeState.maxQuestionIndex == gradeState.currentQuestionIndex,
  };

  switch (gradeState.currentQuestion.variantsType) {
    case 'v_choose_one':
      var $checked = $('.grade_container form').find('input[type="radio"]:checked');
      result.answers = { title: $checked.parent().find('input[type="hidden"]').val(), };
      break;

    case 'v_match':
      var matching = true;
      $.each($('.grade_container .q_left_side input[type="hidden"]'), function (ind, input) {
        if ($(input).val() != $('.q_right_side .quizz_drop').eq(ind).find('input').val()) {
          matching = false;
          return matching;
        }
      });

      result.answers = { matching: matching };
      break;

    case 'v_reorder':
      $.each($('.grade_container form').serializeArray(), function (_ind, data) {
        result.answers.push({ title: data.value });
      });

      break;
  }

  return result;
}
