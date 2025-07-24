class SearchQueriesController < ApplicationController
  def index; end

  def create
    @query = SearchQuery.new(search_query_params)
    @query.ip_address = request.remote_ip

    if @query.save
      redirect_to search_queries_path, notice: 'Registered search query successfully.'
    else
      render :index, alert: 'Error creating search query.'
    end
  end

  private

  def search_query_params
    params.require(:search_query).permit(:query, :ip_address)
  end
end