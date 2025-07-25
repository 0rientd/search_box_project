module SearchQueriesHelper
  def all_trending_queries
    SearchQuery.group(:query).order('count_id DESC').limit(5).count(:id)
  end

  def format_trend_information(trend)
    return if trend.blank?

    "#{trend.first} (#{trend.last} hits)"
  end
end
