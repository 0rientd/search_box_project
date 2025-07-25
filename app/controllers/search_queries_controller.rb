class SearchQueriesController < ApplicationController
  def index; end

  def create
    @query = SearchQuery.new(search_query_params)
    @query.ip_address = request.remote_ip
    article = Article.find_by(title: @query.term)

    respond_to do |format|
      if article && @query.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: show_articles }),
            turbo_stream.replace("sub_menu", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:term).order('count_id DESC').limit(5).count(:id) })
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: show_articles }),
            turbo_stream.replace("sub_menu", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:term).order('count_id DESC').limit(5).count(:id) })
          ]
        end
      end
    end
  end

  def trending
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("sub_menu", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:term).order('count_id DESC').limit(5).count(:id) })
        ]
      end
    end
  end

  def analytics
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("sub_menu", partial: "search_queries/partials/analytics", locals: { analytics: SearchQuery.where(ip_address: request.remote_ip) })
        ]
      end
    end
  end

  def top_searches
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("analytics", partial: "search_queries/partials/top_ten_queries_analytics", locals: { analytics: SearchQuery.where(ip_address: request.remote_ip).group(:term).order('count_id DESC').limit(10).count(:id) })
        ]
      end
    end
  end

  private

  def search_query_params
    params.require(:search_query).permit(:term, :ip_address)
  end

  def show_articles
    if params[:search_query][:term].blank?
      return Article.none
    else
      return Article.where("title LIKE '%#{@query.term}%'")
    end
  end
end