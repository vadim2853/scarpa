module ByMonthable
  def by_month(date)
    return all unless date.present?

    parsed_date = date.to_date

    where(posted_on: parsed_date.beginning_of_month..parsed_date.end_of_month)
  end

  def archive_options
    select("DISTINCT ON (posted_on) date_trunc('month', posted_on) as posted_on")
      .order('posted_on DESC')
      .map(&:posted_on)
  end
end
