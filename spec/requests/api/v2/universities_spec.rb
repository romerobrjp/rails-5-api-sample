require 'rails_helper'

RSpec.describe 'Universities API', type: :request do
  before { host! 'punkapi.com' }

  let!(:api_version) { 'v2' }
  let(:headers) do
    {
      'Accept' => 'application/fractal.punk.v2',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'GET /universities' do
    context 'when exists at least one university' do
      before do
        create_list(:university, 5)
        get "/#{api_version}/universities", params: {}, headers: headers
      end

      it 'returns the universities' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /universities/:id' do
    let(:university) { create(:university) }
    before { get "/#{api_version}/universities/#{university.id}", params: {}, headers: headers }
    
    context 'when the university exists' do
      it 'returns the university' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(university.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the university does not exists' do
      before { get "/#{api_version}/universities/999999" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'PATCH /universities/:id' do
    let(:university) { create(:university) }

    context 'when the params are valid' do
      let!(:university_params) { attributes_for(:university, name: 'Universidade Federal da Caixa Bozó') }
      before { patch "/#{api_version}/universities/#{university.id}", params: { university: university_params } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the university with the field updated' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('Universidade Federal da Caixa Bozó')
      end
    end

    context 'when the params are invalid (:name)' do
      let(:university_params) { { university: { name: '' } } }
      before { patch "/#{api_version}/universities/#{university.id}", params: university_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('name')
      end

      it 'does not update the university in the database' do
        expect(University.find_by(name: university_params[:name])).to be_nil
      end
    end

    context 'when the university does not exists' do
      before do 
        patch "/#{api_version}/universities/999999", params: { university: { name: 'Universidade Federal da Caixa Bozó' } }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /universities/:id' do
    let!(:university) { create(:university) }

    context 'when university exists in the database' do
      before { delete "/#{api_version}/universities/#{university.id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the university from the database' do
        expect { University.find(university.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when university does not exists in the database' do
      before { delete "/#{api_version}/universities/999999", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'FIND_BY_ACRONYM /universities/find_by_acronym/university[:acronym]' do
    context 'when the university exists' do
      let(:university) { create(:university) }
      
      before do
        get "/#{api_version}/universities/find_by_acronym", params: { university: { acronym: university.acronym } }, headers: headers
      end

      it 'returns the university' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(university.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the university does not exists' do
      let(:university) { create(:university) }
      
      before do
        get "/#{api_version}/universities/find_by_acronym", params: { university: { acronym: university.acronym+'zzz' } }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end