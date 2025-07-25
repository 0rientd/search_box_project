require 'rails_helper'

RSpec.describe SearchQueriesController, type: :request do
  describe 'POST /search_queries' do
    let!(:article) { Article.create!(title: "Brazil") }

    context 'with turbo_stream in post request' do
      context 'with no term in params' do
        it "grant the response there's turbo in response" do
          post search_queries_path, params: { search_query: { term: "" } }, as: :turbo_stream

          expect(response).to have_http_status(:ok)
          expect(response.body).to include("turbo-stream")
        end
      end

      context 'with a term with the same name with article title' do
        it "grant the response there's turbo in response and save the search" do
          expect { post search_queries_path, params: { search_query: { term: "Brazil" } }, as: :turbo_stream }.to change(SearchQuery, :count).by(1)
        
          expect(response.body).to include("last_queries")
          expect(response.body).to include("sub_menu")
          expect(response.body).to include("turbo-stream")
        end
      end

      context 'with a term different from article' do
        it "grant the response there's turbo in response and save the search" do
          post search_queries_path, params: { search_query: { term: "Space" } }, as: :turbo_stream
        
          expect(response.body).to include("last_queries")
          expect(response.body).to include("turbo-stream")
          expect(response.body).to include("sub_menu")
        end
      end
    end

    # context 'with no turbo_stream in post request' do
    #   context 'with no term in params' do
    #     it "grant there's no turbo in response" do
    #       post search_queries_path, params: { search_query: { term: "" } }

    #       expect(response).to_not have_http_status(:ok)
    #       expect(response.body).to_not include("turbo-stream")
    #     end
    #   end
    # end
  end
end