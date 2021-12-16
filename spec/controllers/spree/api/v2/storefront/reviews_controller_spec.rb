require 'spec_helper'

RSpec.describe Spree::Api::V2::Storefront::ReviewsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe 'GET /product/:product_id/reviews' do
    let!(:product_1) { create(:product) }
    let!(:product_2) { create(:product) }

    let!(:review_1) { create(:review, product: product_1, approved: true) }
    let!(:review_2) { create(:review, product: product_1, approved: false) }
    let!(:review_3) { create(:review, product: product_1, approved: true) }
    let!(:review_4) { create(:review, product: product_1, approved: true) }
    let!(:review_5) { create(:review, product: product_2, approved: true) }

    context "with valid product_id" do
      context "without params with_feedback" do
        it 'return approved review of the product with the newest first' do
          get :index, params: {product_id: product_1.id}
          response_body = JSON.parse(response.body)
  
          expect(response.status).to eq 200
          expect(response_body["data"].count).to eq 3
          expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_4.id, review_3.id, review_1.id]
        end
      end

      context "with params with_feedback = 1" do
        it 'return approved review (include feedback) of the product with the newest first' do
          get :index, params: {product_id: product_1.id, with_feedback: '1'}
          response_body = JSON.parse(response.body)

          expect(response.status).to eq 200
          expect(response_body["data"].count).to eq 3
          expect(response_body["data"][0]["attributes"]).to have_key("avg_feedback_stars")
          expect(response_body["data"][0]["attributes"]).to have_key("has_current_user_feedback")
          expect(response_body["data"][0]["attributes"]).to have_key("is_own_review")
          expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_4.id, review_3.id, review_1.id]
        end
      end
      
    end

    context "with invalid product_id" do
      it 'response error with status 404' do
        get :index, params: {product_id: 'invalid'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(response_body["error"]).to eq "The resource you were looking for could not be found."
      end
    end
  end

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
