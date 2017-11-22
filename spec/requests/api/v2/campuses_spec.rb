require 'rails_helper'

RSpec.describe 'Campuses API', type: :request do
  before { host! 'punkapi.com' }

  let!(:university) { create(:university) }
  let!(:api_version) { 'v2' }
  let(:headers) do
    {
      'Accept' => 'application/fractal.punk.v2',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'GET /campuses' do
    context 'when exists at least one campus' do
      before do
        create_list(:campus, 5, university_id: university.id)
        get "/#{api_version}/campuses", params: {}, headers: headers
      end

      it 'returns the campuses' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /campuses/:id' do
    let(:campus) { create(:campus, university_id: university.id) }
    before { get "/#{api_version}/campuses/#{campus.id}", params: {}, headers: headers }
    
    context 'when the campus exists' do
      it 'returns the campus' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(campus.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the campus does not exists' do
      before { get "/#{api_version}/campuses/999999" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'PATCH /campuses/:id' do
    let(:campus) { create(:campus, university_id: university.id) }

    context 'when the params are valid' do
      let!(:campus_params) { attributes_for(:campus, name: 'Conxixola') }
      before { patch "/#{api_version}/campuses/#{campus.id}", params: { campus: campus_params } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the campus with the field updated' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('Conxixola')
      end
    end

    context 'when the params are invalid (:name)' do
      let(:campus_params) { { campus: { name: '' } } }
      before { patch "/#{api_version}/campuses/#{campus.id}", params: campus_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('name')
      end

      it 'does not update the campus in the database' do
        expect(Campus.find_by(name: campus_params[:name])).to be_nil
      end
    end

    context 'when the campus does not exists' do
      before do 
        patch "/#{api_version}/campuses/999999", params: { campus: { name: 'Universidade Federal da Caixa Bozó' } }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /campuses/:id' do
    let!(:campus) { create(:campus, university_id: university.id) }

    context 'when campus exists in the database' do
      before { delete "/#{api_version}/campuses/#{campus.id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the campus from the database' do
        expect { Campus.find(campus.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when campus does not exists in the database' do
      before { delete "/#{api_version}/campuses/999999", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'FIND_BY_NAME /campuses/find_by_name/campus[:name]' do
    context 'when the campus exists' do
      let(:campus) { create(:campus, university_id: university.id) }
      
      before do
        get "/#{api_version}/campuses/find_by_name", params: { campus: { name: campus.name } }, headers: headers
      end

      it 'returns the campus' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(campus.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the campus does not exists' do
      let(:campus) { create(:campus, university_id: university.id) }
      
      before do
        get "/#{api_version}/campuses/find_by_name", params: { campus: { name: campus.name+'zzz' } }, headers: headers
      end
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'FIND_BY_CITY /campuses/find_by_city/campus[:city]' do
    context 'when there is at least on campus from that city' do
      let(:campus) { create(:campus, university_id: university.id) }

      before do
        get "/#{api_version}/campuses/find_by_city", params: { campus: { city: campus.city } }, headers: headers
      end

      it 'returns the campuses' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the are no campuses from that city' do
      let(:campus) { create(:campus, university_id: university.id) }
      
      before do
        get "/#{api_version}/campuses/find_by_city", params: { campus: { name: campus.name+'zzz' } }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end