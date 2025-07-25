module SearchQueriesHelper
  def all_trending_queries
    SearchQuery.group(:query).order('count_id DESC').limit(5).count(:id)
  end

  def format_trend_information(trend)
    return if trend.blank?

    "#{trend.first} (#{trend.last} hits)"
  end
  
  def format_analytics_information(analytic)
    return if analytic.blank?

    "Query: #{analytic.query} | (From #{analytic.ip_address})"
  end
  
  def format_top_ten_information(analytic)
    return if analytic.blank?

    "Query: #{analytic.first} (#{analytic.last} hits)"
  end
end
