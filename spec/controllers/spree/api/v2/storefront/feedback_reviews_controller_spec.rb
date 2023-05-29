require 'spec_helper'

RSpec.describe Spree::Api::V2::Storefront::FeedbackReviewsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe 'POST /reviews/:review_id/feedback_reviews' do
    context "with user login and valid data" do
      it 'create feedback review and response success' do
        set_resource_owner_token

        review = create(:review, user: create(:user))
        feedback_review_params = {
          rating: 4,
          comment: 'Good service'
        }

        post :create, params: {review_id: review.id, feedback_review: feedback_review_params}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response_body["data"]["type"]).to eq 'feedback_review'
        expect(response_body["data"]["relationships"]["user"]["data"]["id"].to_i).to eq @oauth_resource_owner.id
        expect(response_body["data"]["relationships"]["review"]["data"]["id"].to_i).to eq review.id
      end
    end

    context "with user login and invalid review_id" do
      it 'response error with status 404' do
        set_resource_owner_token

        post :create, params: {review_id: 'invalid'}
        response_body = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(response_body["error"]).to eq "The resource you were looking for could not be found."
      end
    end

    context "without user login" do
      it 'response error with status 403' do
        review = create(:review)
        post :create, params: {review_id: review.id}

        response_body = JSON.parse(response.body)

        expect(response.status).to eq 403
        expect(response_body["error"]).to eq "You are not authorized to access this page."
      end
    end
  end
end
