# frozen_string_literal: true

RSpec.describe Semvruler::Semversion do
  describe '#<=>' do
    shared_examples 'compares correctly' do
      let(:version1) { described_class.parse(format1, safe: false) }
      let(:version2) { described_class.parse(format2, safe: false) }
      subject { version1 <=> version2 }

      it { is_expected.to be comparison }
    end

    context 'when Same version' do
      let(:comparison) { 0 }

      context 'and format valid' do
        let(:format1) { '3.10.6' }
        let(:format2) { '3.10.6' }

        it_behaves_like 'compares correctly'
      end

      context 'and format is complete' do
        let(:format1) { '3.10.6--alpha-a.b-c---somethinglong.1+build.0' }
        let(:format2) { '3.10.6--alpha-a.b-c---somethinglong.1+build.1' }

        it_behaves_like 'compares correctly'
      end
    end

    context 'when with lower precedence due core numbers' do
      let(:format1) { '3.7.6' }
      let(:format2) { '3.10.6' }
      let(:comparison) { -1 }

      it_behaves_like 'compares correctly'
    end

    context 'when with higher precedence due core numbers' do
      let(:format1) { '3.7.9' }
      let(:format2) { '3.7.6' }
      let(:comparison) { 1 }

      it_behaves_like 'compares correctly'
    end

    context 'when lower precedence due prelease' do
      let(:format1) { '3.7.6-alpha.0' }
      let(:format2) { '3.7.6' }
      let(:comparison) { -1 }

      it_behaves_like 'compares correctly'
    end

    context 'when higher precedence due prelease' do
      let(:format1) { '3.7.6' }
      let(:format2) { '3.7.6-beta' }
      let(:comparison) { 1 }

      it_behaves_like 'compares correctly'
    end

    context 'when lower precedence due prerelease order' do
      let(:format1) { '3.7.6-0.1.alpha' }
      let(:format2) { '3.7.6-20.1.alpha' }
      let(:comparison) { -1 }

      it_behaves_like 'compares correctly'
    end

    context 'when higher precedence due prerelease order' do
      let(:format1) { '3.7.6-beta.0.1' }
      let(:format2) { '3.7.6-alpha.20.1' }
      let(:comparison) { 1 }

      it_behaves_like 'compares correctly'
    end

    context 'when lower precedence due prerelease length' do
      let(:format1) { '3.7.6-0.1.alpha' }
      let(:format2) { '3.7.6-0.1.alpha.0' }
      let(:comparison) { -1 }

      it_behaves_like 'compares correctly'
    end
  end

  describe '~>' do
    subject { ver1.send('~>', ver2) }

    context 'when version goes beyond patch lock' do
      let(:ver1) { described_class.parse('3.1.0') }
      let(:ver2) { described_class.parse('3.0.3') }
      it 'is false' do
        is_expected.to be false
      end
    end

    context 'when version falls below patch lock' do
      let(:ver1) { described_class.parse('3.0.2') }
      let(:ver2) { described_class.parse('3.0.3') }
      it 'is false' do
        is_expected.to be false
      end
    end

    context 'when version is between patch locks valid range' do
      let(:ver1) { described_class.parse('3.0.3') }
      let(:ver2) { described_class.parse('3.0.3') }
      it 'is true' do
        is_expected.to be true
      end
    end

    context 'when version goes beyond lock' do
      let(:ver1) { described_class.parse('2.0') }
      let(:ver2) { described_class.parse('1.1') }
      it 'is false' do
        is_expected.to be false
      end
    end

    context 'when version falls below lock' do
      let(:ver1) { described_class.parse('1.0') }
      let(:ver2) { described_class.parse('1.1') }
      it 'is false' do
        is_expected.to be false
      end
    end

    context 'when version is between patch locks valid range' do
      let(:ver1) { described_class.parse('1.5') }
      let(:ver2) { described_class.parse('1.1') }
      it 'is true' do
        is_expected.to be true
      end
    end
  end

  describe '::parse' do
    subject { described_class.parse(format, safe: false) }

    context 'when valid format' do
      let(:format) { '3.10.6--alpha-a.b-c---somethinglong.1+build.1-aef.1-its-okay' }
      let(:expected_major) { 3 }
      let(:expected_minor) { 10 }
      let(:expected_patch) { 6 }
      let(:expected_prerelease) { ['-alpha-a', 'b-c---somethinglong', '1'] }
      let(:expected_build) { 'build.1-aef.1-its-okay' }

      it 'captures major correctly' do
        expect(subject.major).to be expected_major
      end

      it 'captures minor correctly' do
        expect(subject.minor).to be expected_minor
      end

      it 'captures patch correctly' do
        expect(subject.patch).to be expected_patch
      end

      it 'captures prerelease correctly' do
        expect(subject.prerelease).to eq expected_prerelease
      end

      it 'captures build correctly' do
        expect(subject.build).to eq expected_build
      end
    end

    context 'invalid format' do
      let(:format) { '9.8.7-whatever+meta+meta' }

      it 'raises exception' do
        expect { subject }.to raise_exception described_class::FormatError
      end
    end
  end
end
