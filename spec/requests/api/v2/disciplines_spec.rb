require 'rails_helper'

RSpec.describe 'Disciplines API', type: :request do
  before { host! 'punkapi.com' }

  let!(:api_version) { 'v2' }
  let(:headers) do
    {
      'Accept' => 'application/fractal.punk.v2',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'GET /disciplines' do
    context 'when there is at least one discipline' do
      before do
        create_list(:discipline, 5)
        get "/#{api_version}/disciplines", params: {}, headers: headers
      end

      it 'returns the disciplines' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /disciplines/:id' do
    let(:discipline) { create(:discipline) }
    before { get "/#{api_version}/disciplines/#{discipline.id}", params: {}, headers: headers }
    
    context 'when the discipline exists' do
      it 'returns the discipline' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(discipline.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the discipline does not exists' do
      before { get "/#{api_version}/disciplines/999999" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'PATCH /disciplines/:id' do
    let(:discipline) { create(:discipline) }

    context 'when the params are valid' do
      let!(:discipline_params) { attributes_for(:discipline, name: 'Conxixola') }
      before { patch "/#{api_version}/disciplines/#{discipline.id}", params: { discipline: discipline_params } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the discipline with the field updated' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('Conxixola')
      end
    end

    context 'when the params are invalid (:name)' do
      let(:discipline_params) { { discipline: { name: '' } } }
      before { patch "/#{api_version}/disciplines/#{discipline.id}", params: discipline_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json error for name' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to have_key('name')
      end

      it 'does not update the discipline in the database' do
        expect(Discipline.find_by(name: discipline_params[:name])).to be_nil
      end
    end

    context 'when the discipline does not exists' do
      before do 
        patch "/#{api_version}/disciplines/999999", params: { discipline: { name: 'Universidade Federal da Caixa Bozó' } }
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /disciplines/:id' do
    let!(:discipline) { create(:discipline) }

    context 'when discipline exists in the database' do
      before { delete "/#{api_version}/disciplines/#{discipline.id}", params: {}, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the discipline from the database' do
        expect { Discipline.find(discipline.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when discipline does not exists' do
      before { delete "/#{api_version}/disciplines/999999", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'FIND_BY_NAME /disciplines/find_by_name/discipline[:name]' do
    context 'when the discipline exists' do
      let(:discipline) { create(:discipline) }
      
      before do
        get "/#{api_version}/disciplines/find_by_name", params: { discipline: { name: discipline.name } }, headers: headers
      end

      it 'returns the discipline' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(discipline.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the discipline does not exists' do
      let(:discipline) { create(:discipline) }
      
      before do
        get "/#{api_version}/disciplines/find_by_name", params: { discipline: { name: discipline.name+'zzz' } }, headers: headers
      end
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'FIND_BY_DESCRIPTION /disciplines/find_by_description/discipline[:description]' do
    let!(:disciplines) { create_list(:discipline, 10) }

    context 'when there is at least one discipline with the part of informed description' do
      
      before do
        get(
          "/#{api_version}/disciplines/find_by_description",
          params: {
            discipline: { description: disciplines[rand(0..9)].description.split(' ')[0] }
          }, 
          headers: headers
        )
      end
      
      it 'returns the disciplines' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the are no disciplines with that description' do
      before do
        get "/#{api_version}/disciplines/find_by_description", params: { discipline: { description: 'insane discipline' } }, headers: headers
      end
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'GET#FIND_BY_PROFESSOR_NAME /disciplines/find_by_professor_name' do
    let!(:university) { create(:university) }
    let!(:campus) { create(:campus, university_id: university.id) }
    let!(:discipline) { create(:discipline) }
    let!(:professors) { create_list(:professor, 5, campus_id: campus.id, university_id: university.id, discipline_ids: discipline.id) }

    context 'when there is at least one discipline allocated to that professor' do

      before do
        get "/#{api_version}/disciplines/find_by_professor_name", params: { professor_name: professors[0].name }, headers: headers
      end

      it 'returns the disciplines' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to be > 0
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when there are no disciplines from that professor' do
      before do
        get "/#{api_version}/disciplines/find_by_professor_name", params: { professor_name: professors[0].name+"zzz" }, headers: headers
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end