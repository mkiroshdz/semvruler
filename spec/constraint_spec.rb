# frozen_string_literal: true

RSpec.describe Semvruler::Constraint do
  describe '::parse' do
    subject { described_class.parse(format) }

    shared_examples 'valid format' do
      it { expect(subject.version.to_s).to eq expected_version }
      it { expect(subject.type).to eq expected_type }
    end

    shared_examples 'invalid format' do
      it { expect(subject).to be nil }
    end

    context 'when valid rule' do
      let(:format) { '~> 2.5.6' }
      let(:expected_type) { '~>' }
      let(:expected_version) { '2.5.6' }

      it_behaves_like 'valid format'

      context 'and no type specified' do
        let(:format) { '2.5.6' }
        let(:expected_type) { '=' }

        it_behaves_like 'valid format'
      end
    end

    context 'when invalid type' do
      let(:format) { '/ 2.5.6' }

      it_behaves_like 'invalid format'
    end

    context 'when invalid version' do
      let(:format) { '>= 02.5.6' }

      it_behaves_like 'invalid format'
    end
  end

  describe '#match?' do
    subject { described_class.parse(constraint).match?(version) }

    shared_examples 'is a match' do
      it { is_expected.to be true }
    end

    shared_examples 'is not a match' do
      it { is_expected.to be false }
    end

    context 'for eq lock' do
      context 'when other version is different' do
        let(:constraint) { '= 2.5.0' }
        let(:version) { '2.5.0-pr.0' }
        it_behaves_like 'is not a match'
      end

      context 'when other version is equal' do
        let(:constraint) { '2.5.0' }
        let(:version) { '2.5.0+build.0' }
        it_behaves_like 'is a match'
      end
    end

    context 'for not eq lock' do
      let(:constraint) { '!= 2.5.0' }

      context 'when other version is different' do
        let(:version) { '2.5.0-pr.0' }
        it_behaves_like 'is a match'
      end

      context 'when other version is eq' do
        let(:version) { '2.5.0+build.0' }
        it_behaves_like 'is not a match'
      end
    end

    context 'for gte pesimistic lock' do
      let(:constraint) { '~> 2.5.0' }

      context 'when version goes beyond upper bound' do
        let(:version) { '3.0.0' }
        it_behaves_like 'is not a match'
      end

      context 'when version falls below lower bound' do
        let(:version) { '2.4.9' }
        it_behaves_like 'is not a match'
      end

      context 'when version lies between the valid range' do
        let(:version) { '2.9.2' }
        it_behaves_like 'is a match'
      end
    end

    context 'for gte optimistic lock' do
      let(:constraint) { '>= 2.5.0' }

      context 'when version falls below lower bound' do
        let(:version) { '2.4.9' }
        it_behaves_like 'is not a match'
      end

      context 'when version lies between the valid range' do
        let(:version) { '4.3.2' }
        it_behaves_like 'is a match'
      end
    end

    context 'for gt lock' do
      let(:constraint) { '> 2.5.0' }

      context 'when version falls below lower bound' do
        let(:version) { '2.5.0' }
        it_behaves_like 'is not a match'
      end

      context 'when version lies between the valid range' do
        let(:version) { '2.5.1' }
        it_behaves_like 'is a match'
      end
    end

    context 'for lte lock' do
      let(:constraint) { '<= 2.5.0' }

      context 'when version goes beyond upper bound' do
        let(:version) { '2.5.1' }
        it_behaves_like 'is not a match'
      end

      context 'when version lies between the valid range' do
        let(:version) { '2.4.9' }
        it_behaves_like 'is a match'
      end
    end

    context 'for lt lock' do
      let(:constraint) { '< 2.5.0' }

      context 'when version goes beyond upper bound' do
        let(:version) { '2.5.0' }
        it_behaves_like 'is not a match'
      end

      context 'when version lies between the valid range' do
        let(:version) { '2.4.9' }
        it_behaves_like 'is a match'
      end
    end
  end
end
