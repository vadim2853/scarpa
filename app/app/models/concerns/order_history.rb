module OrderHistory
  def years_of_completed_orders
    orders
      .select("DISTINCT CAST(DATE_PART('year', spree_orders.completed_at) AS int) AS completed_year")
      .where('spree_orders.completed_at IS NOT NULL')
      .order('completed_year DESC')
      .map(&:completed_year)
  end

  def months_of_completed_orders_by(year:)
    orders
      .select("DISTINCT CAST(DATE_PART('month', spree_orders.completed_at) AS int) AS completed_month")
      .where("DATE_PART('year', spree_orders.completed_at) = ?", year)
      .order('completed_month DESC')
      .map(&:completed_month)
  end

  def completed_orders_by(year:, month:)
    orders
      .where("DATE_PART('year', completed_at) = ? AND DATE_PART('month', completed_at) = ?", year, month)
      .order(completed_at: :desc)
  end
end
