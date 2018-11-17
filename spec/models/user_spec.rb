require 'rails_helper'
# require 'spec_helper'
require 'byebug'



RSpec.describe User, type: :model do
  describe 'password encryption' do
    it 'does not save passwords to the database' do
      User.create!(username: 'jack_black', password: 'abcdef')
      user = User.find_by_username('jack_black')
      expect(user.password).not_to be('abcdef')
    end

    it 'encrypts the password using BCrypt' do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: 'jack_bruce', password: 'abcdef')
    end
  end

  describe '::find_by_credentials' do ###
    rose = User.create(username: 'Rose', password: 'password')
    it 'finds user by username and password' do

      user = User.find_by_credentials('Rose', 'password')
      expect(user.username).to eq(rose.username)
    end
  end

  describe 'session token' do
    it 'assigns a session_token if one is not given' do
      jack = User.create(username: 'jack_bruce', password: 'abcdef')
      expect(jack.session_token).not_to be_nil
    end
  end

  it { should validate_length_of(:password).is_at_least(6) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  # it { should have_many(:links).class_name(:) }
  # it { should have_many(:comments).class_name(:) }
end
