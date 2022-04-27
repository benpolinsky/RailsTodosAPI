require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

# These tests have bit a _tad_ flakey
# TimeCop should resolve those issues and allow a more-complete suite

RSpec.describe 'Items', type: :request do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:headers) { valid_headers }

  describe 'GET /todos/:todo_id/items' do
    let(:time_now) { DateTime.new(2021, 2, 3, 4, 5, 6) }
    before { travel_to(time_now) }

    context 'rate limit per-second for any request' do
      let(:valid_attributes) do
        { title: 'Prepare rails projects', created_by: user.id.to_s }.to_json
      end

      it 'only allows three requests in a one-second interval' do
        3.times do |_n|
          get "/todos/#{todo_id}/items", params: {}, headers: headers
          expect(response).to have_http_status(200)
        end

        get "/todos/#{todo_id}/items", params: {}, headers: headers
        expect(response).to have_http_status(429)

        travel_to(DateTime.new(2021, 2, 3, 4, 5, 7))

        get "/todos/#{todo_id}/items", params: {}, headers: headers
        expect(response).to have_http_status(200)
      end

      it 'limits all requests - write' do
        3.times do
          post '/todos', params: valid_attributes, headers: headers
          expect(response).to have_http_status(201)
        end

        post '/todos', params: valid_attributes, headers: headers
        expect(response).to have_http_status(429)

        travel_to(DateTime.new(2021, 2, 3, 4, 5, 7))
        post '/todos', params: valid_attributes, headers: headers
        expect(response).to have_http_status(201)
      end

      it 'limits all requests - read + write' do
        3.times do
          get "/todos/#{todo_id}/items", params: {}, headers: headers
          expect(response).to have_http_status(200)
        end

        get "/todos/#{todo_id}/items", params: {}, headers: headers
        expect(response).to have_http_status(429)

        travel_to(DateTime.new(2021, 2, 3, 4, 5, 7))
        post '/todos', params: valid_attributes, headers: headers
        expect(response).to have_http_status(201)
      end
    end

    context 'rate limit per-hour for read requests' do
      it 'only allows 40 read requests in an one-hour interval' do
        40.times do |i|
          travel_to(DateTime.new(2021, 2, 3, 5, 5, 6 + i + 1))
          get "/todos/#{todo_id}/items", params: {}, headers: headers
          expect(response).to have_http_status(200)
        end

        get "/todos/#{todo_id}/items", params: {}, headers: headers
        expect(response).to have_http_status(429)
        travel_to(DateTime.new(2021, 2, 3, 6, 5, 6 + 41))

        get "/todos/#{todo_id}/items", params: {}, headers: headers
        expect(response).to have_http_status(200)
      end
    end

    context 'rate limit per 30 minutes for write requests' do
      let(:valid_attributes) do
        { title: 'Prepare rails projects', created_by: user.id.to_s }.to_json
      end

      it 'only allows 25 write requests in an 30 minute interval', focus: true do
        25.times do |i|
          travel_to(DateTime.new(2021, 2, 3, 5, 5, 6 + i + 1))
          post '/todos', params: valid_attributes, headers: headers
          expect(response).to have_http_status(201)
        end

        post '/todos', params: valid_attributes, headers: headers
        expect(response).to have_http_status(429)

        travel_to(DateTime.new(2021, 2, 3, 5, 35, 6 + 26))

        post '/todos', params: valid_attributes, headers: headers
        expect(response).to have_http_status(201)
      end
    end
  end
end
