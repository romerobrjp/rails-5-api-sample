require 'rails_helper'

RSpec.describe 'Professores API', type: :request do
  before { host! 'punkapi.com' }

  let!(:university) { create(:university) }
  let!(:campus) { create(:campus, university_id: university.id) }
  let!(:api_version) { 'v2' }
  let(:headers) do
    {
      'Accept' => 'application/fractal.punk.v2',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'GET /professors' do
    context 'when there is at least one professor' do
      before do
        create_list(:professor, 5, university_id: university.id, campus_id: campus.id)
        get "/#{api_version}/professors", params: {}, headers: headers
      end

      it 'returns the professors' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /professors/:id' do
    let(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }
    before { get "/#{api_version}/professors/#{professor.id}", params: {}, headers: headers }
    
    context 'when the professor exists' do
      it 'returns the professor' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(professor.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the professor does not exists' do
      before { get "/#{api_version}/professors/999999" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'PATCH /professors/:id' do
    let(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }

    context 'when the params are valid' do
      let!(:professor_params) { attributes_for(:professor, name: 'Conxixola') }
      before { patch "/#{api_version}/professors/#{professor.id}", params: { professor: professor_params } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the professor with the field updated' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('Conxixola')
      end
    end

    context 'when the params are invalid (:name)' do
      let(:professor_params) { { professor: { name: '' } } }
      before { patch "/#{api_version}/professors/#{professor.id}", params: professor_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('name')
      end

      it 'does not update the professor in the database' do
        expect(Professor.find_by(name: professor_params[:name])).to be_nil
      end
    end

    context 'when the professor does not exists' do
      before do 
        patch "/#{api_version}/professors/999999", params: { professor: { name: 'Universidade Federal da Caixa Bozó' } }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /professors/:id' do
    let!(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }

    context 'when professor exists in the database' do
      before { delete "/#{api_version}/professors/#{professor.id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the professor from the database' do
        expect { Professor.find(professor.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when professor does not exists' do
      before { delete "/#{api_version}/professors/999999", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'FIND_BY_NAME /professors/find_by_name/professor[:name]' do
    context 'when the professor exists' do
      let(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }
      
      before do
        get "/#{api_version}/professors/find_by_name", params: { professor: { name: professor.name } }, headers: headers
      end

      it 'returns the professor' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(professor.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the professor does not exists' do
      let(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }
      
      before do
        get "/#{api_version}/professors/find_by_name", params: { professor: { name: professor.name+'zzz' } }, headers: headers
      end
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'GET#FIND_BY_UNIVERSITY_NAME /professors/find_by_university_name' do
    let!(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }

    context 'when there is at least one professor from that university' do

      before do
        get "/#{api_version}/professors/find_by_university_name", params: { university_name: university.name }, headers: headers
      end

      it 'returns the professors' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when there are no professors from that university' do
      before do
        get "/#{api_version}/professors/find_by_university_name", params: { university_name: university.name+"zzz" }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET#FIND_BY_UNIVERSITY_ACRONYM /professors/find_by_university_acronym' do
    let!(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }

    context 'when there is at least one professor from that university with the specified acronym' do

      before do
        get "/#{api_version}/professors/find_by_university_acronym", params: { university_acronym: university.acronym }, headers: headers
      end

      it 'returns the professors' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when there are no professors from that university with the specified acronym' do
      before do
        get "/#{api_version}/professors/find_by_university_acronym", params: { university_acronym: university.acronym+"zzz" }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET#FIND_BY_FORMATION_AREA /professors/find_by_formation_area' do
    let!(:professor) { create(:professor, university_id: university.id, campus_id: campus.id) }

    context 'when there is at least one professor with that formation area(s)' do

      before do
        get "/#{api_version}/professors/find_by_formation_area", params: { professor: { formation_area: professor.formation_area } }, headers: headers
      end

      it 'returns the professors' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when there are no professors with that formation area(s)' do
      before do
        get "/#{api_version}/professors/find_by_formation_area", params: { professor: { formation_area: professor.formation_area+"zzz" } }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end