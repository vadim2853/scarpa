window.addRelatedNewsEntry = function (e) {
  e.preventDefault();
  var relatedId = $('#related_ids').val();
  var newsEntryId = $(this).data('news-entry-id');
  $.ajax({
    type: 'POST',
    url: '/admin/related_news_entries',
    data: { related_id: relatedId, id: newsEntryId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

window.deleteRelatedNewsEntry = function (e) {
  e.preventDefault();
  var relatedId = $(this).data('related-id');
  var newsEntryId = $(this).data('news-entry-id');
  $.ajax({
    type: 'DELETE',
    url: '/admin/related_news_entries/' + newsEntryId,
    data: { related_id: relatedId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

$(function () {
  $('.add-related-news-entry-link').click(window.addRelatedNewsEntry);
  $('.delete-related-news-entry-link').click(window.deleteRelatedNewsEntry);
});
