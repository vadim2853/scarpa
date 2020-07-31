font_100 = Rails.root.join('app/assets/fonts/museosanscyrl_100.ttf')
font_300 = Rails.root.join('app/assets/fonts/museosanscyrl_300.ttf')
font_900 = Rails.root.join('app/assets/fonts/museosanscyrl_900.ttf')
font_baskerville = Rails.root.join('app/assets/fonts/baskerville.ttf')
background_image = Rails.root.join('app/assets/images/certificate_template.png')
nomination_icon = @result.nomination.icon.path || Rails.root.join('app/assets/images/grade_bg.png')

document_options = {
  info: { Title: @result.user.full_name },
  margin: [20, 20, 20, 20],
  page_layout: :landscape,
  page_size: 'A4'
}

prawn_document(document_options) do |pdf|
  pdf.image background_image, fit: [802, 555], position: :left, vposition: 5
  pdf.image nomination_icon, at: [375, 200], width: 50, height: 100

  pdf.font(font_baskerville) do
    pdf.font_size 24
    pdf.move_cursor_to 399
    pdf.text @result.user.full_name, align: :center, character_spacing: 1.2

    pdf.font_size 37
    pdf.text_box quotes(" #{@result.grade.title} "), at: [100, 335],
                                                     overflow: :shrink_to_fit,
                                                     character_spacing: 1.2,
                                                     width: 602,
                                                     height: 80,
                                                     align: :center
  end

  pdf.font(font_900) do
    pdf.font_size 11
    pdf.move_cursor_to 228
    pdf.text quotes(@result.nomination.title).upcase, align: :center, color: 'EC2226', character_spacing: 3
  end

  pdf.font(font_300) do
    style = { align: :center, character_spacing: 5 }

    pdf.font_size 8

    pdf.move_cursor_to 363
    pdf.text 'YOU HAVE SUCCESSFULLY PASSED', style

    pdf.move_cursor_to 255
    pdf.text 'AND GRANTED WITH A RANK OF', style
  end

  pdf.font(font_100) do
    style = { align: :center, character_spacing: 1.5 }

    pdf.font_size 9
    pdf.move_cursor_to 56
    pdf.text 'via Montegrappa, 6 - 14049 Nizza Monferrato AT  Tel. +39 0141 721331 - Fax. +39 0141 702872', style
    pdf.text 'info@scarpavini.it - export@scarpavini.it', style
  end
end
