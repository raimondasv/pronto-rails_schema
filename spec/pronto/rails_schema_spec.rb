require 'spec_helper'

describe Pronto::RailsSchema do
  it 'has a version number' do
    expect(Pronto::RailsSchemaVersion::VERSION).not_to be nil
  end

  subject { described_class.new(patches, nil).run }
  let(:schema_present) { true }

  before do
    allow(File).to receive(:exist?).with('db/schema.rb').and_return(schema_present)
  end

  context 'with no patches' do
    let(:patches) { nil }
    it 'adds no messages' do
      expect(subject.count).to eq 0
    end
  end

  context 'with patch but without migration files' do
    include_context 'test repo'
    let(:patches) { repo.diff('4618a01a062aa18aeb205b250004acd1468a6867') }

    it 'adds no messages' do
      expect(subject.count).to eq 0
    end
  end

  context 'with migration' do
    include_context 'test repo'
    context 'with schema.rb changes' do
      let(:patches) { repo.diff('7e2f4ef7fde653c7d96e12cf4a909198a72801e9') }

      it 'adds no messages' do
        expect(subject.count).to eq 0
      end
    end

    context 'without schema.rb changes' do
      let(:patches) { repo.diff('27be4d9a6f63bf8ccf515d4b32d3f230d0c34613') }

      it 'adds warning message' do
        expect(subject.first.msg).to match(/Migration/)
      end

      context 'without schema file' do
        let(:schema_present) { false }

        it 'adds no messages' do
          expect(subject.count).to eq 0
        end
      end
    end
  end
end
