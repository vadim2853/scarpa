//= require tooltipster

$(document).on('page:change', function () {
  if (DISPLAY_COMING_SOON) {
    $('.coming_soon_link').tooltipster({
      trigger: 'click',
      timer: 1000,
      theme: 'tooltipster_scarpa',
    });
  }
});
