# frozen_string_literal: true

RSpec.describe Semvruler::Rule do
  describe '::parse' do
    subject { described_class.parse(format) }

    context 'valid format' do
      let(:format) { '= 2.3.4' }
      it 'returns rule' do
        expect(subject[format].to_s).to eq format
      end
    end

    context 'invalid format' do
      let(:format) { '==2.3.4' }
      it 'raises exception' do
        expect { subject }.to raise_exception Semvruler::Semversion::FormatError
      end
    end
  end

  describe '#add' do
    let(:format) { '!= 3.1.2' }
    subject { described_class.parse('2.3.4') }
    before { subject.add(format) }
    it 'includes rule' do
      expect(subject[format].to_s).to eq format
    end
  end

  describe '#remove' do
    let(:format) { '!= 3.1.2' }
    subject { described_class.parse(['2.3.4', format]) }
    before { subject.remove(format) }
    it 'excludes rule' do
      expect(subject[format]).to be nil
    end
  end

  describe '#merge' do
    let(:format) { '!= 3.1.2' }
    let(:rule1) { described_class.parse(['< 1.3.4', '< 1.0.0-pr.0', format]) }
    let(:rule2) { described_class.parse(['< 1.3.4', '< 1.0.0-pr.0']) }
    subject { rule1.merge(rule2) }
    it 'adds all rules' do
      expect(subject.size).to be 3
      expect(subject[format].to_s).to eq format
    end
  end
end
