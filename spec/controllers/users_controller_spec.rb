# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user, password: 'Password123') }

  describe 'POST #signup' do
    context 'with invalid params' do
      it 'returns errors' do
        post :signup, params: { user: { email: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Email can't be blank")
      end
    end
  end

  describe 'POST #login' do
    context 'with non-existent user' do
      it 'returns user not found error' do
        post :login, params: { email: 'nonexistent@example.com', password: 'Password123' }
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('User not found')
      end
    end
  end

  describe 'POST #forgot_password' do
    context 'with missing email' do
      it 'returns error' do
        post :forgot_password, params: { email: '' }
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Email not present')
      end
    end

    context 'with invalid email' do
      it 'returns not found error' do
        post :forgot_password, params: { email: 'invalid@example.com' }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Email address not found. Please check and try again.')
      end
    end
  end

  describe 'POST #resend_code' do
    context 'with missing token' do
      it 'returns error' do
        post :resend_code, params: { token: '' }
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Token not present')
      end
    end

    context 'with invalid token' do
      it 'returns user not found' do
        post :resend_code, params: { token: 'invalidtoken' }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('User not found')
      end
    end
  end

  describe 'POST #reset_password' do
    let(:token) { jwt_encode(user_id: user.id) }
    context 'with missing token' do
      it 'returns token missing error' do
        post :reset_password, params: { token: '', password: 'NewPassword123', confirm_password: 'NewPassword123' }
        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Token not present')
      end
    end
  end
end
