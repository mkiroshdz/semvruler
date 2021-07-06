# frozen_string_literal: true

RSpec.describe Semvruler do
  it 'has a version number' do
    expect(Semvruler::VERSION).not_to be nil
  end

  describe '::rule' do
    context 'when multiple values' do
      let(:format) { ['~> 2.0.4', '2.0.0', '>= 4.3.1', '< 2.3.1', '> 3.0.0-pr.0'] }
      subject { Semvruler.rule(*format).send(:constraints).values }

      it 'correctly init rules' do
        expect(subject.map(&:to_s)).to eq format
      end
    end

    context 'when single value' do
      let(:format) { '>= 4.3.1' }
      subject { Semvruler.rule(*format).send(:constraints).values }

      it 'correctly init rules' do
        expect(subject.first.to_s).to eq format
      end
    end
  end

  describe '::version' do
    let(:version) { '3.10.6-alpha.0+build.1' }
    subject { Semvruler.version(version) }

    it 'correctly init version from string' do
      expect(subject.to_s).to eq version
    end
  end

  describe '::versions' do
    let(:versions) { %w[5.1.0 2.2.0-pr0 10.2.1+build.1] }
    subject { Semvruler.versions(versions) }

    it 'correctly init versions' do
      expect(subject.map(&:to_s)).to eq versions
    end
  end

  describe 'Rule Matching' do
    let(:format) { ['> 1.0.0', '>= 2.3.0', '~> 2.4.0', '< 2.9.9', '<= 2.7.0', '!= 2.6.0'] }
    subject { Semvruler.rule(*format) }

    context 'when version does not match the rules' do
      it 'matching returns false' do
        ['0.4.1', '1.1.1', '3.0.0', '2.9.9', '2.8.0', '2.6.0'].each do |version|
          expect(subject.match?(version)).to be false
        end
      end
    end

    context 'when version does match the rules' do
      it 'matching returns false' do
        ['2.7.0', '2.6.5', '2.6.1', '2.5.0', '2.4.0'].each do |version|
          expect(subject.match?(version)).to be true
        end
      end
    end
  end

  describe 'Sorting' do
    let(:versions) do
      %w[
        0.1.0
        0.2.0
        0.2.1
        1.0.0-alpha
        1.0.0-alpha.1
        1.0.0-alpha.beta
        1.0.0-beta
        1.0.0-beta.1
        1.0.0-beta.2
        1.0.0-beta.11
        1.0.0-rc.1
        1.0.0
        1.0.0
        2.0.0
        2.1.0-0.alpha
        2.1.0-1.pr
        2.1.0-2.pr
        2.1.0-10.pr
        2.1.0-10.pr.1
        2.1.0
        2.1.1
      ]
    end

    subject { Semvruler.versions(versions.shuffle).sort }

    it 'returns versions in correct order' do
      expect(subject.map(&:to_s)).to eq versions
    end
  end

  describe 'Filtering' do
    let(:versions) { ['2.1.4', '3.0.0', '2.6.8'] }
    let(:rule) { Semvruler.rule('~> 2.0.0', '< 2.6.9') }

    describe 'select' do
      subject { versions.select(&rule) }
      it 'returns correct values' do
        is_expected.to eq ['2.1.4', '2.6.8']
      end
    end

    describe 'find' do
      subject { versions.find(&rule) }
      it 'returns correct values' do
        is_expected.to eq '2.1.4'
      end
    end
  end
end
