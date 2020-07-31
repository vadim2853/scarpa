window.addMonthProduct = function (e) {
  e.preventDefault();
  var monthId = $(this).data('month-id');
  var productId = $('#month_products_ids').val();
  $.ajax({
    type: 'POST',
    url: '/admin/calculator/month_products/',
    data: { product_id: productId, id: monthId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

window.deleteMonthProduct = function (e) {
  e.preventDefault();
  var monthId = $(this).data('month-id');
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'DELETE',
    url: '/admin/calculator/month_products/' + monthId,
    data: { product_id: productId }, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

$(function () {
  $('.add-month-product-link').click(window.addMonthProduct);
  $('.delete-month-product-link').click(window.deleteMonthProduct);
});
