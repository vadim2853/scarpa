$(document).on('page:change', function () {
  $selector = $('select.archive');

  $selector
    .select2({ minimumResultsForSearch: -1 })
    .on('change', handleChange($selector.data('path')));
});

var handleChange = function (path) {
  return function (e) {
    Turbolinks.visit(e.val === '' ? path : path + '?by_month=' + e.val);
  };
};
