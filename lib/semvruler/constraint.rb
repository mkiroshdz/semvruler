# frozen_string_literal: true

module Semvruler
  class Constraint
    FORMAT = /^((?<type>=|!=|~>|>=|>|<=|<)\s*)?(?<version>.*)$/.freeze

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
        capture = FORMAT.match(value)
        assert_format(capture, safe)
      end

      def assert_format(capture, safe)
        version = Semversion.parse(capture[:version], safe: safe) if capture
        if capture && version
          new(capture[:type], version)
        else
          raise FormatError unless safe

          nil
        end
      end
    end

    attr_reader :version

    def to_s
      "#{type_as_string}#{version}"
    end

    def initialize(type, version)
      @type = type
      @version = version
    end

    def type
      @type || '='
    end

    def match?(other)
      other = Semversion.parse(other, safe: false)
      other.send(operation, version)
    end

    protected

    def operation
      type == '=' ? '==' : type
    end

    private

    def type_as_string
      "#{@type} " if @type
    end
  end
end
