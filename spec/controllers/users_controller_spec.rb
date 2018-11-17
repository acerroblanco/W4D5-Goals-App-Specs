require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'GET #new' do
    it 'renders the new users page' do
      get :new, user: {}

      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  context 'with invalid params' do
    it 'validates the presence of username' do
      post :create, params: { user: { username: 'this is an invalid username' } }
      expect(response).to render_template('new')
      expect(flash[:errors]).to be_present
    end
  end

  context 'with valid params' do
    it 'redirects to the user show page' do
      post :create, params: { user: { username: 'Nav Ram', password: 'password' } }
      expect(response).to redirect_to(link_url(User.last))
    end
  end


  describe 'POST #create' do
    it 'creates new users' do
      get :create, user: {}

      expect(response).to redirect_to(user_url(user))
      expect(response).to have_http_status(200)
    end

    context 'with invalid params' do
      it 'validates the presence of the user\'s username and password' do
        post :create, params: { user: { username: 'jack_bruce', password: '' } }
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end

      it 'validates that the password is at least 6 characters long' do
        post :create, params: { user: { username: 'jack_bruce', password: 'short' } }
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid params' do
      it 'redirects user to links index on success' do
        post :create, params: { user: { username: 'jack_bruce', password: 'password' } }
        expect(response).to redirect_to(links_url)
      end

      it 'logs in the user' do
        post :create, params: { user: { username: 'jack_bruce', password: 'password' } }
        user = User.find_by_username('jack_bruce')

        expect(session[:session_token]).to eq(user.session_token)
      end
    end

  end





end
