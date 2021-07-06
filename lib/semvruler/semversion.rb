# frozen_string_literal: true

module Semvruler
  class Semversion
    include Comparable

    FORMAT = /
      ^
      (?<major>0|[1-9]\d*)\.
      (?<minor>0|[1-9]\d*)
      (\.(?<patch>0|[1-9]\d*))?
      (-(?<prerelease>(0|[1-9]\d*|\d*[a-z-][0-9a-z-]*)(\.(0|[1-9]\d*|\d*[a-z-][0-9a-z-]*))*))?
      (\+(?<build>[0-9a-z-]+(\.[0-9a-z-]+)*))?
      $
    /xi.freeze

    class FormatError < StandardError
      def initialize(msg = 'Invalid format for version')
        super
      end
    end

    class << self
      def parse(value, safe: true)
        if value.respond_to?(:map)
          value.map { |item| cast(item, safe) }
        else
          cast(value, safe)
        end
      end

      private

      def cast(value, safe)
        captures = FORMAT.match(value)

        if captures
          new(captures)
        else
          raise FormatError unless safe

          nil
        end
      end
    end

    attr_reader :major, :minor, :patch, :prerelease, :build

    def to_s
      "#{core_as_string}#{prerelease_as_string}#{build_as_string}"
    end

    def initialize(format)
      @major = format[:major].to_i
      @minor = format[:minor].to_i
      @patch = format[:patch].to_i
      @build = format[:build]
      @prerelease = format[:prerelease]&.split('.') || []
      @order = Order.new(@major, @minor, @patch, *@prerelease)
    end

    def <=>(other)
      order <=> other.order
    end

    define_method('~>') do |other|
      ceil_major = other.patch.positive? ? other.major : other.major + 1
      ceil_minor = other.patch.positive? ? other.minor + 1 : 0
      self < self.class.new(major: ceil_major, minor: ceil_minor, patch: 0) && self >= other
    end

    protected

    attr_reader :order

    private

    def core_as_string
      "#{major}.#{minor}.#{patch}"
    end

    def prerelease_as_string
      return if prerelease.empty?

      str = prerelease.join('.')
      "-#{str}"
    end

    def build_as_string
      return unless build

      "+#{build}"
    end
  end
end
