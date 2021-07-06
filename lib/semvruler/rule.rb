# frozen_string_literal: true

module Semvruler
  class Rule
    class << self
      def parse(value)
        constraints = Array(Constraint.parse(value, safe: false))
        new(constraints)
      end
    end

    def initialize(constraints)
      @constraints = Hash[constraints.map { |c| [c.to_s, c] }]
    end

    def [](idx)
      constraints[idx]
    end

    def size
      constraints.size
    end

    def add(value)
      constraint = Constraint.parse(value)
      constraints[constraint.to_s] = constraint
    end

    def remove(value)
      constraint = Constraint.parse(value)
      constraints.delete(constraint.to_s)
    end

    def merge(other)
      new_constraints = [*constraints.values, *other.constraints.values]
      self.class.new(new_constraints)
    end

    def match?(version)
      constraints.values.all? { |c| c.match?(version) }
    end

    def to_proc
      ->(version) { match?(version) }
    end

    protected

    attr_reader :constraints
  end
end
