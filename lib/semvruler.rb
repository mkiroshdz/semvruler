# frozen_string_literal: true

require 'set'
require_relative 'semvruler/version'
require_relative 'semvruler/order'
require_relative 'semvruler/semversion'
require_relative 'semvruler/constraint'
require_relative 'semvruler/rule'

module Semvruler
  class Error < StandardError; end

  class << self
    %i[versions version].each do |method_name|
      define_method(method_name) do |value|
        Semversion.parse(value)
      end
    end

    def rule(*value)
      Rule.parse(value)
    end
  end
end
