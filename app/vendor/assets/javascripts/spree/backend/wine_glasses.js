// jscs:disable requireTrailingComma

window.addWineGlass = function (e) {
  e.preventDefault();
  var wineGlassId = $('#wine_glasses_ids').val();
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'POST',
    url: '/admin/wine_glasses',
    data: { wine_glass_id: wineGlassId, id: productId } // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

window.deleteWineGlass = function (e) {
  e.preventDefault();
  var wineGlassId = $(this).data('wine-glass-id');
  var productId = $(this).data('product-id');
  $.ajax({
    type: 'DELETE',
    url: '/admin/wine_glasses/' + productId,
    data: { wine_glass_id: wineGlassId } // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
  });
};

$(function () {
  $('.add-wine-glass-link').click(window.addWineGlass);
  $('.delete-wine-glass-link').click(window.deleteWineGlass);
  $('#product_is_winery_glass').on('click', function () {
    if ($(this).is(':checked')) {
      $('div[data-hook="admin_product_form_wine_glasses"]').hide();
      $('.wine_glass_box').hide();
    } else {
      $('div[data-hook="admin_product_form_wine_glasses"]').show();
      $('.wine_glass_box').show();
    }
  });
});
