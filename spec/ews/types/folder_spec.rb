require 'spec_helper'

describe Viewpoint::EWS::Types::Folder do
  let(:ews) do
    double('ews',
      auto_deepen?: false,
      no_auto_deepen_behavior: nil)
  end
  let(:ews_item) { { item_id: { attribs: { id: 'unused'} }, elems: {} } }

  before do
    allow(ews).to receive(:auto_deepen)

    soap_resp = load_soap 'find_item', :response
    opts = { response_class: Viewpoint::EWS::SOAP::EwsResponse }
    response = Viewpoint::EWS::SOAP::EwsParser.new(soap_resp).parse(opts)
    expect(ews).to receive(:find_item).and_return(response)
  end

  context '#items' do
    let(:items) { subject.items }

    subject { described_class.new(ews, ews_item) }

    it 'handles an "item" element' do
      expect(items[0].body).to eq('Item body')
      expect(items[0].id).to eq('AQAnAH')
    end
  end

  context '#paging' do
    let(:items) { subject.items }

    subject { described_class.new(ews, ews_item) }

    it 'returns includes_last_item_in_range' do
      expect(items.includes_last_item_in_range).to eq(true)
    end

    it 'returns indexed_paging_offset' do
      expect(items.indexed_paging_offset).to eq(2)
    end
  end
end
