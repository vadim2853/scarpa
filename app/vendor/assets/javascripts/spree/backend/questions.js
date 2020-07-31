jQuery(function ($) {
  $(document).ready(function () {
    $(document).on('click', '.right_variant input[type="radio"]', function () {
      $(this).parents('tbody').find('input[type="radio"]').not(this).attr({ checked: false });
    });

    $(document).on('click', '.remove_question_variant', function () {
      if ($('table tbody').hasClass('left_variants')) {
        var index = $(this).parents('tr').index();
        $('.left_variants tr').eq(index).remove();
        $('.right_variants tr').eq(index).remove();
      } else {
        $(this).parents('tr').remove();
      }
    });

    var fixHelper = function (e, ui) {
      ui.children().each(function () {
        $(this).width($(this).width());
      });

      return ui;
    };

    $('table.question_variants_sortable').ready(function () {
      var tdCount = $(this).find('tbody tr:first-child td').length;
      $('table.question_variants_sortable tbody').sortable(
        {
          handle: '.handle',
          helper: fixHelper,
          placeholder: 'ui-sortable-placeholder',
        });
    });

    $('#question_variants_type').on('change', function () {
      $('#progress').show();
      document.location.href = document.location.pathname + '?f=' + $(this).val();
    });

    if (document.location.search.includes('?f=v_')) {
      setTimeout(function () {
        $('html, body').animate({ scrollTop: $(document).height() }, 1000);
      }, 500);
    }

    var uniqueVariantId = 1;
    $('.spree_add_variants').unbind('click').on('click', function (e) {
      var hash = Math.random().toString(36).substr(2, 9);
      $.each(['.right_variants', '.left_variants'], function (ind, val) {
        var target = val;
        var newTableRow = $(target + ' tr:visible:last').clone();

        newTableRow.find('.select2-container').remove();
        newTableRow.find('.property_group select')
                     .val('<%= Spree::Property.groups.keys.first %>')
                     .trigger('change')
                     .select2({ minimumResultsForSearch: -1 });
        newTableRow.find('.type_of_value select')
                     .val('text')
                     .select2({ minimumResultsForSearch: -1 });

        var newId = new Date().getTime() + (uniqueVariantId++);
        newTableRow.find('input, select').each(function () {
          var $el = $(this);
          $el.val('');

          // Replace last occurrence of a number
          $el.prop('id', $el.prop('id').replace(/\d+(?=[^\d]*$)/, newId));
          $el.prop('name', $el.prop('name').replace(/\d+(?=[^\d]*$)/, newId));
        });

        newTableRow.find('.right_variant input[type="radio"]')
                     .val('true')
                     .attr({ checked: false });

        newTableRow.find('.right_variant input[type="checkbox"]')
                     .val('1')
                     .attr({ checked: false });

        var match = newTableRow.find('.to_match_box input[type="hidden"]');
        var tableSide = match.parent();
        match.val(tableSide.data('match'));
        newTableRow.find('.to_match_box .match_id_field').val(hash);

        // When cloning a new row, set the href of all icons to be an empty "#"
        // This is so that clicking on them does not perform the actions for the
        // duplicated row
        newTableRow.find('a').each(function () {
          var $el = $(this);
          $el.prop('href', '#');
        });

        $(target).prepend(newTableRow);

        newTableRow.find('.select2-search-choice-close').remove();
      });
    });
  });
});
