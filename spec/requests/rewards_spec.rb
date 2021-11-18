# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rewards', type: :request do
  describe 'GET /' do
    it 'has a 200 status code' do
      get :/

      expect(response.status).to eq(200)
    end
  end

  describe 'post /rewards' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/files/input.txt") }

    it 'has a 200 status code' do
      post reward_path, params: { file: file }

      expect(response.status).to eq(302)
    end
  end
end
