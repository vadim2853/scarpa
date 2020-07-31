window.addEventProduct = function (e) {
  e.preventDefault();
  var eventId = $(this).data('event-id');
  var productId = $('#event_products_ids').val();
  $.ajax({
    type: 'POST',
    url: '/admin/calculator/event_products/',
    data: { product_id: productId, id: eventId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

window.deleteEventProduct = function (e) {
  e.preventDefault();
  var eventId = $(this).data('event-id');
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'DELETE',
    url: '/admin/calculator/event_products/' + eventId,
    data: { product_id: productId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

$(function () {
  $('.add-event-product-link').click(window.addEventProduct);
  $('.delete-event-product-link').click(window.deleteEventProduct);
});
