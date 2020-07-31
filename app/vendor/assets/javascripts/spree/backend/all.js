// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require ckeditor/init
//= require spree/backend/i18n
//= require spree/backend/admin
//= require spree/backend/questions
//= require spree/backend/wine_glasses
//= require spree/backend/related_products
//= require spree/backend/product_properties
//= require spree/backend/spree_multi_currency
//= require spree/backend/calculator/month_products
//= require spree/backend/calculator/event_products
//= require spree/backend/spree_paypal_express

$(document).on('ready', function () {
  $('.select2_without_search_and_close').select2({ minimumResultsForSearch: -1 });
  $('.select2_without_search_and_close').find('.select2-search-choice-close').remove();
});
