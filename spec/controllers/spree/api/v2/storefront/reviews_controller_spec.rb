require 'spec_helper'

RSpec.describe Spree::Api::V2::Storefront::ReviewsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe 'POST /product/:product_id/reviews' do
    context "with user login and valid data" do
      it 'response success' do
        set_resource_owner_token
        prodcut = create(:product)

        review_params = {
          rating: 4,
          title: 'Test',
          review: 'Good Serivce',
          name: 'Tom',
          show_identifier: '1'
        }

        post :create, params: {product_id: prodcut.id, review: review_params}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"]["type"]).to eq 'review'
        expect(response_body["data"]["attributes"]["name"]).to eq review_params[:name]
        expect(response_body["data"]["relationships"]["user"]["data"]["id"].to_i).to eq @oauth_resource_owner.id
        expect(response_body["data"]["relationships"]["product"]["data"]["id"].to_i).to eq prodcut.id
      end
    end

    context "with user login and invalid product_id" do
      it 'response error with status 404' do
        set_resource_owner_token

        post :create, params: {product_id: 'invalid'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(response_body["error"]).to eq "The resource you were looking for could not be found."
      end
    end

    context "without user login" do
      it 'response error with status 403' do
        prodcut = create(:product)
        post :create, params: {product_id: prodcut.id}
        
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 403
        expect(response_body["error"]).to eq "You are not authorized to access this page."
      end
    end
  end
end
