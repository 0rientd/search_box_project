class SearchQueriesController < ApplicationController
  def index; end

  def create
    @query = SearchQuery.new(search_query_params)
    @query.ip_address = request.remote_ip
    article = Article.find_by(title: @query.query)

    respond_to do |format|
      if article && @query.save
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: SearchQuery.last(2).reverse }), # USE SAME FUNCTIONALITY TO BRING SEARCHES IN REAL TIME IN THE FIELD
              turbo_stream.replace("trending", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:query).order('count_id DESC').limit(5).count(:id) })
            ]
          end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: SearchQuery.none }), # USE SAME FUNCTIONALITY TO BRING SEARCHES IN REAL TIME IN THE FIELD
            turbo_stream.replace("trending", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:query).order('count_id DESC').limit(5).count(:id) })
          ]
        end
      end
    end
  end

  def trending
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("trending", partial: "search_queries/partials/trending", locals: { trending: SearchQuery.group(:query).order('count_id DESC').limit(5).count(:id) })
        ]
      end
    end
  end

  # def analytics
    # @analytics = SearchQuery.group(:query).order('count_id DESC').count(:id)
    # respond_to do |format|
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace("analytics_queries", partial: "search_queries/partials/analytics_queries", locals: { queries: @analytics }) }
    #   format.html { render :analytics }
    # end
  # end

  private

  def search_query_params
    params.require(:search_query).permit(:query, :ip_address)
  end
end