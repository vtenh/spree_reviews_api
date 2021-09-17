require 'spec_helper'

RSpec.describe Spree::Api::V2::Storefront::Account::ReviewsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe 'GET /account/reviews' do
    context "without user login" do
      it 'response error 403' do
        get :index
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 403
        expect(response_body["error"]).to eq "You are not authorized to access this page."
      end
    end
    
    context "with user login" do
      before(:each) do
        set_resource_owner_token
      end

      let!(:review_1) { create(:review, user: @oauth_resource_owner, approved: true) }
      let!(:review_2) { create(:review, user: @oauth_resource_owner, approved: false) }
      let!(:review_3) { create(:review, user: @oauth_resource_owner, approved: true) }
      let!(:review_4) { create(:review, user: @oauth_resource_owner, approved: true) }
      let!(:review_5) { create(:review, approved: true) }

      it 'return all the reviews of the user with oldest first if param oldest = 1' do
        get :index, params: {oldest: 1}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"].count).to eq 4
        expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_1.id, review_2.id, review_3.id, review_4.id]
      end

      it 'return all review of the user with the newest first if the param aprroved is not passed' do
        get :index
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"].count).to eq 4
        expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_4.id, review_3.id, review_2.id, review_1.id]
      end

      it 'returnn approved review of the user with the newest first if the params approved = 1' do
        get :index, params: {approved: 1}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"].count).to eq 3
        expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_4.id, review_3.id, review_1.id]
      end

      it 'return unapproved review of the user with the newest first if the params approved = 0' do
        get :index, params: {approved: 0}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"].count).to eq 1
        expect(response_body["data"].map{|r| r["id"].to_i}).to match [review_2.id]
      end
    end
  end
end
