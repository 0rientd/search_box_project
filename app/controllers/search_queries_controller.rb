class SearchQueriesController < ApplicationController
  def index; end

  def create
    @query = SearchQuery.new(search_query_params)
    @query.ip_address = request.remote_ip
    article = Article.find_by(title: @query.query)

    if article
      respond_to do |format|
        if @query.save
          format.turbo_stream { render turbo_stream: turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: SearchQuery.last(10).reverse }) }
          format.html { redirect_to root_path, notice: 'Registered search query successfully.' }
        else
          format.turbo_stream { render turbo_stream: turbo_stream.replace("last_queries", partial: "search_queries/partials/query_results", locals: { queries: SearchQuery.last(10).reverse }) }
          format.html { redirect_to root_path, alert: 'Error creating search query.' }
        end
      end
    end
  end

  private

  def search_query_params
    params.require(:search_query).permit(:query, :ip_address)
  end
end