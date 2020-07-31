// jscs:disable requireTrailingComma

window.addRelatedProduct = function (e) {
  e.preventDefault();
  var relatedId = $('#related_ids').val();
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'POST',
    url: '/admin/related_products',
    data: { related_id: relatedId, id: productId } // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

window.deleteRelatedProduct = function (e) {
  e.preventDefault();
  var relatedId = $(this).data('related-id');
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'DELETE',
    url: '/admin/related_products/' + productId,
    data: { related_id: relatedId } // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

$(function () {
  $('.add-related-product-link').click(window.addRelatedProduct);
  $('.delete-related-product-link').click(window.deleteRelatedProduct);
});
