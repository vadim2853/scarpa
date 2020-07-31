document_options = {
  margin: [0, 0, 0, 0],
  page_size: 'A4'
}

options = {
  logo: Rails.root.join('app/assets/images/scarpa_logo.png'),
  font_100: Rails.root.join('app/assets/fonts/museosanscyrl_100.ttf'),
  font_300: Rails.root.join('app/assets/fonts/museosanscyrl_300.ttf'),
  font_baskerville: Rails.root.join('app/assets/fonts/baskerville.ttf'),
  a4_width: 595.28,
  a4_height: 841.89,
  line_step: 30,
  lines_y_start: 720.89,
  header_bottom: 752.89,
  body_x_multiplier: 0.073,
  header_2_sector_left: 129,
  header_3_sector_left: 418,
  frame_x_multiplier_1: 0.027,
  frame_x_multiplier_2: 0.038,
  frame_y_multiplier_1: 0.019,
  frame_y_multiplier_2: 0.027,

  line_x_end: 551.82456,
  line_x_start: 43.455439999999996,
  border_inner_top: 819.15897,
  border_inner_left: 22.620639999999998,
  border_inner_right: 572.65936,
  line_x_col_2_start: 319.36771999999996,

  sub_column_length: 70.24304000000002,
  sub_column_space: 10.863859999999988,

  line_x_col_2_2_start: 400.47461999999996,
  line_x_col_2_3_start: 481.58151999999995
}

options.merge!(
  style: {
    width: 508.36912,
    height: options[:line_step],
    overflow: :shrink_to_fit,
    character_spacing: 1,
    align: :left,
    valign: :bottom
  }
)

draw_border = ->(pdf, frame_x_multiplier, frame_y_multiplier) do
  pdf.stroke_rectangle(
    [
      options[:a4_width] * frame_x_multiplier,
      options[:a4_height] - options[:a4_height] * frame_y_multiplier
    ],
    options[:a4_width] - (options[:a4_width] * frame_x_multiplier) * 2,
    options[:a4_height] - (options[:a4_height] * frame_y_multiplier) * 2
  )
end

draw_frame = ->(pdf) do
  pdf.stroke_color 'F6AF40'
  pdf.line_width = 2

  pdf.image(
    options[:logo],
    at: [
      options[:border_inner_left] + (options[:header_2_sector_left] - options[:border_inner_left]) * 0.2,
      options[:a4_height] - options[:a4_height] * options[:frame_y_multiplier_2] * 1.7
    ],
    width: (options[:header_2_sector_left] - options[:border_inner_left]) * 0.6
  )

  draw_border.(pdf, options[:frame_x_multiplier_1], options[:frame_y_multiplier_1])

  draw_border.(pdf, options[:frame_x_multiplier_2], options[:frame_y_multiplier_2])

  pdf.stroke_horizontal_line(
    options[:border_inner_left],
    options[:a4_width] - options[:border_inner_left],
    at: options[:header_bottom]
  )

  pdf.stroke_vertical_line options[:border_inner_top], options[:header_bottom], at: options[:header_2_sector_left]
  pdf.stroke_vertical_line options[:border_inner_top], options[:header_bottom], at: options[:header_3_sector_left]

  pdf.line_width = 1
  pdf.stroke_color '000000'

  pdf.font(options[:font_100]) do
    style = { align: :center, character_spacing: 1.35 }

    pdf.font_size 9
    pdf.move_cursor_to 66
    pdf.text 'via Montegrappa, 6 - 14049 Nizza Monferrato AT  Tel. +39 0141 721331 - Fax. +39 0141 702872', style
    pdf.text 'info@scarpavini.it - export@scarpavini.it', style
  end

  pdf.font(options[:font_baskerville]) do
    pdf.font_size 24

    style = {
      height: options[:border_inner_top] - options[:header_bottom] - 20,
      overflow: :shrink_to_fit,
      character_spacing: 3,
      align: :center,
      valign: :center
    }

    pdf.text_box "INVOICE #{@order.number}", style.merge(
      at: [options[:header_2_sector_left] + 10, options[:border_inner_top] - 10],
      width: options[:header_3_sector_left] - options[:header_2_sector_left] - 20
    )

    pdf.text_box @order.completed_at.strftime('%d.%m.%y'), style.merge(
      at: [options[:header_3_sector_left] + 10, options[:border_inner_top] - 10],
      width: options[:border_inner_right] - options[:header_3_sector_left] - 20
    )
  end
end

line_offset = ->(n) { options[:lines_y_start] - options[:line_step] * n }
offset = ->(n) { [options[:line_x_start], line_offset.(n)] }

table_header_at = ->(pdf, n) do
  pdf.font(options[:font_300]) do
    pdf.font_size 8

    pdf.text_box 'ITEM NAME:', options[:style].merge(at: offset.(n))
    pdf.text_box 'ITEMS:', options[:style].merge(at: [options[:line_x_col_2_2_start], line_offset.(n)])
    pdf.text_box 'PRICE PER ITEM:', options[:style].merge(at: [options[:line_x_col_2_3_start], line_offset.(n)])
  end
end

list_entry = ->(pdf, line, name, items, price) do
  pdf.font(options[:font_baskerville]) do
    pdf.font_size 16

    pdf.text_box truncate(name, length: 50), options[:style].merge(at: offset.(line))

    style = options[:style].merge(
      height: options[:line_step] / 2,
      valign: :top,
      width: options[:sub_column_length]
    )

    pdf.text_box items.to_s, style.merge(at: [options[:line_x_col_2_2_start], line_offset.(line + 0.5)])
    pdf.text_box price.to_s, style.merge(at: [options[:line_x_col_2_3_start], line_offset.(line + 0.5)])
  end
end

draw_first_page_template = ->(pdf) do
  draw_frame.(pdf)

  2.times do |n|
    pdf.stroke_horizontal_line(
      options[:line_x_start],
      options[:line_x_end],
      at: options[:lines_y_start] - options[:line_step] * (2 + 4 * n)
    )
  end

  pdf.stroke_horizontal_line(
    options[:line_x_start],
    options[:a4_width] / 2 - options[:line_x_start] / 2,
    at: line_offset.(4)
  )

  pdf.stroke_horizontal_line(
    options[:line_x_col_2_start],
    options[:line_x_end],
    at: line_offset.(4)
  )

  pdf.stroke_horizontal_line(
    options[:line_x_start],
    options[:line_x_end],
    at: line_offset.(7)
  )

  10.times do |n|
    pdf.stroke_horizontal_line(
      options[:line_x_start],
      options[:line_x_end],
      at: options[:lines_y_start] - options[:line_step] * (10 + n)
    )
  end

  pdf.font(options[:font_300]) do
    pdf.font_size 12

    style_spacing_32 = options[:style].merge(character_spacing: 3.2)

    pdf.text_box 'PAYMENT DETAILS', style_spacing_32.merge(at: offset.(-1))
    pdf.text_box 'PAYMENT SUMMARY', style_spacing_32.merge(at: offset.(7))

    pdf.font_size 8

    pdf.text_box 'NAME:', options[:style].merge(at: offset.(0))
    pdf.text_box 'IBAN:', options[:style].merge(at: offset.(2))
    pdf.text_box 'SWIFT:', options[:style].merge(
      at: [
        options[:line_x_col_2_start],
        options[:lines_y_start] - options[:line_step] * 2
      ]
    )
    pdf.text_box 'PAYMENT DESCRIPTION:', options[:style].merge(at: offset.(4))
  end

  pdf.font(options[:font_baskerville]) do
    pdf.font_size 16

    style_spacing_25 = options[:style].merge(character_spacing: 2.5)

    pdf.text_box 'SCARPA VINI', style_spacing_25.merge(at: offset.(1))
    pdf.text_box 'IT38 INGB 9812 3458 12', style_spacing_25.merge(at: offset.(3))
    pdf.text_box 'INGB IT 2C', style_spacing_25.merge(
      at: [
        options[:line_x_col_2_start],
        options[:lines_y_start] - options[:line_step] * 3
      ]
    )
  end

  table_header_at.(pdf, 8)
end

draw_next_page_template = ->(pdf) do
  pdf.start_new_page

  draw_frame.(pdf)

  19.times do |n|
    pdf.stroke_horizontal_line(
      options[:line_x_start],
      options[:line_x_end],
      at: options[:lines_y_start] - options[:line_step] * (1 + n)
    )
  end

  table_header_at.(pdf, -1)
end

print_description = -> (pdf, text) do
  pdf.font(options[:font_baskerville]) do
    pdf.font_size 16

    pdf.text_box text, options[:style].merge(
      at: offset.(5.5),
      valign: :top,
      height: options[:line_step] * 1.5,
      leading: 16
    )
  end
end

print_total_price = -> (pdf, price) do
  style = options[:style].merge(width: options[:sub_column_length])

  pdf.font(options[:font_300]) do
    pdf.font_size 8

    pdf.text_box 'TOTAL PRICE:', style.merge(at: [options[:line_x_col_2_3_start], line_offset.(19)])
  end

  pdf.font(options[:font_baskerville]) do
    pdf.font_size 20

    pdf.text_box price.to_s, style.merge(at: [options[:line_x_col_2_3_start], line_offset.(20)])
  end

  pdf.stroke_horizontal_line(options[:line_x_col_2_3_start], options[:line_x_end], at: line_offset.(21))
end

prawn_document(document_options) do |pdf|
  draw_first_page_template.(pdf)

  wines = @order.items_by_taxon(CFG.taxons.wine.title).sum(:quantity)
  wine_tours = @order.items_by_taxon(CFG.taxons.wine_tour.title).sum(:quantity)
  wine_glasses = @order.items_by_taxon(CFG.taxons.wine_glass.title).sum(:quantity)

  description = []

  description << 'wine'.pluralize(wines) unless wines.zero?
  description << 'tour ticket'.pluralize(wine_tours) unless wine_tours.zero?
  description << 'wine glass'.pluralize(wine_glasses) unless wine_glasses.zero?

  print_description.(
    pdf,
    [description[0..-2].join(', '), description.last].reject(&:blank?).join(' and ').mb_chars.capitalize.to_s
  )

  items = @order.line_items
  last_index = 1

  items.first(10).each_with_index do |item, index|
    list_entry.(pdf, 9 + index, item.variant.product.name, item.quantity, item.price.to_f)

    last_index = 9 + index
  end

  if items.count >= 10
    items.from(10).in_groups_of(19, false) do |group|
      draw_next_page_template.(pdf)

      group.each_with_index do |item, index|
        list_entry.(pdf, index, item.variant.product.name, item.quantity, item.price.to_f)

        last_index = index
      end
    end
  end

  unless @order.shipment_total.zero?
    if items.count > 9 && ((items.count - 10) % 19).zero?
      draw_next_page_template.(pdf)

      last_index = -1
    end

    list_entry.(pdf, last_index.next, 'Shipment', '', @order.shipment_total)
  end

  print_total_price.(pdf, @order.total.to_f)
end
