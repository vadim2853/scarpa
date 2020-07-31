
window.renderFormErrors = function (form, modelName, errors) {
  if (typeof errors == 'object') {
    var msgTexts = '';

    window.clearFormErrors(form);

    $.each(errors, function (field, messages) {
      input = form.find('input, select, textarea').filter(function () {
        name = $(this).attr('name');
        if (name) { return name.match(new RegExp(modelName + '\\[' + field + '\\(?')); }
      });

      window.ensureErrorMarks(form, input);

      msgTexts += $.map(messages, function (msg) {
        field = field.replace('_', ' ');
        return field.charAt(0).toUpperCase() + field.slice(1) + ' ' + msg + ';<br />';
      });
    });

    window.insertErrorBox(form, msgTexts, true);

  } else {

    $.each(form.find('input, select, textarea'), function (_key, field) {
      ensureErrorMarks(form, $(field));
    });

    window.insertErrorBox(form, errors);
  }
};

window.ensureErrorMarks = function (form, input) {
  var exclamation = input.parent().find('.exclamation');

  if (exclamation.length) { exclamation.remove(); }

  input.addClass('error').parent().append('<div class="exclamation"></div>');
};

window.clearFormErrors = function (form) {
  form.find('input, select, textarea').removeClass('error');

  form.find('.exclamation').remove();
};

window.insertErrorBox = function (form, message, isSlice) {
  message = isSlice ? message.slice(0, -7) : message;

  if (form.find('.errors_box').length) {
    form.find('.errors_box').html(message).slideDown('fast');
  } else {
    $('<div class="errors_box">' + message + '.</div>')
      .insertBefore(form.find('button'))
      .slideDown('fast');
  }
};

window.isProcessableJson = function (str) {
  try { JSON.parse(str); } catch (e) { return false; }

  return true;
};

function setCookie(cname, cvalue, exdays) {
  if (exdays === undefined) exdays = 1;

  var d = new Date();
  d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
  var expires = 'expires=' + d.toUTCString();
  document.cookie = cname + '=' + cvalue + '; ' + expires;
}

function getCookie(cname) {
  var name = cname + '=';
  var ca = document.cookie.split(';');
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1);
    if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
  }

  return '';
}

function destroyCookie(cname) {
  document.cookie = cname + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
};

function escapeHtml(unsafe) {
  return unsafe.replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/"/g, '&quot;')
       .replace(/'/g, '&#039;');
}
