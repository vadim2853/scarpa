require 'barby'
require 'tempfile'
require 'barby/barcode/code_128'
require 'barby/outputter/rmagick_outputter'

font_300 = Rails.root.join('app/assets/fonts/museosanscyrl_300.ttf')
font_500 = Rails.root.join('app/assets/fonts/museosanscyrl_500.ttf')
font_baskerville = Rails.root.join('app/assets/fonts/baskerville.ttf')
background_image = Rails.root.join('app/assets/images/ticket_bg_01.png')

item_id = "#{@item.order.number}-#{@item.id.to_s.rjust(4, '0')}"
bg_width = 527.53
a4_height = 841.89
ticket_width = 595.28
ticket_height = 280.63

barcode_top = ticket_height - 185
barcode_height = (ticket_width - bg_width)
rotation_center = [bg_width + 1 + (ticket_width - bg_width) * 0.5, barcode_top - barcode_height / 2]

document_options = {
  info: { Title: item_id },
  margin: [0, 0, 0, 0],
  skip_page_creation: true,
  page_size: 'A4' #[595.28, 841.89]
}

prawn_document(document_options) do |pdf|
  @item.quantity.times.each_slice(3) do |tickets|
    pdf.start_new_page

    tickets.each_with_index do |ticket, index|
      pdf.bounding_box([0, a4_height - ticket_height * index], width: ticket_width, height: ticket_height) do |box|
        pdf.dash(5)
        pdf.stroke_horizontal_line 0, ticket_width, at: 0
        pdf.undash

        pdf.image background_image, at: [0, ticket_height], width: bg_width, height: ticket_height - 1

        barcode_file = Tempfile.new([ticket.to_s, '.png'])

        barcode_file.binmode
        #@item.quantity.to_s.rjust(2, '0')
        barcode_file.write Barby::Code128B.new("#{item_id}-#{ticket.next.to_s.rjust(2, '0')}").to_png(height: barcode_height * 0.7)
        barcode_file.rewind

        pdf.rotate(90, origin: rotation_center) do
          pdf.image barcode_file.path, at: [bg_width, barcode_top]
        end

        barcode_file.close(true)

        pdf.stroke_horizontal_line 0, bg_width - 32, at: 216

        pdf.font(font_baskerville) do
          pdf.font_size 29

          pdf.text_box @item.product.name,
            at: [32, 243],
            overflow: :expand,
            character_spacing: 1.2,
            width: bg_width - 64,
            height: 20
        end

        pdf.font(font_500) do
          pdf.font_size 16
          pdf.fill_color '7B072B'

          pdf.text_box @item.variant.presentation,
            at: [32, 175],
            overflow: :expand,
            character_spacing: 1.2,
            width: bg_width - 64,
            height: 20

          pdf.fill_color '000000'
        end

        pdf.font(font_300) do
          pdf.font_size 38

          pdf.text_box "#{@item.price.to_s} €",
            at: [300, 82],
            align: :right,
            valign: :bottom,
            character_spacing: 1.3,
            width: bg_width - 332,
            height: 50
        end
      end
    end
  end
end
