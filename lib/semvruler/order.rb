# frozen_string_literal: true

module Semvruler
  class Order
    def initialize(*chain)
      @chain = chain
    end

    def <=>(other)
      index = (0..2).find { |idx| compare_at(other, idx) != 0 }
      return compare_at(other, index) if index
      return compare_missed_lenght(other) if compare_missed_lenght(other) != 0

      index = (3..[size, other.size].max).find { |idx| compare_at(other, idx) != 0 }
      return compare_at(other, index) if index

      no_difference_found
    end

    protected

    attr_reader :chain

    def no_difference_found
      0
    end

    def compare_missed_lenght(other)
      if size == 3 || other.size == 3
        (size <=> other.size) * -1
      else
        no_difference_found
      end
    end

    def compare_at(other, idx)
      is_numeric = int_at?(idx) || other.int_at?(idx)

      current = is_numeric ? read_int_at(idx) : self[idx].to_s
      nxt = is_numeric ? other.read_int_at(idx) : other[idx].to_s

      current <=> nxt
    end

    def [](idx)
      chain[idx]
    end

    def read_int_at(idx)
      if int_at?(idx)
        self[idx].to_i
      else
        self[idx].nil? ? -1 : Float::INFINITY
      end
    end

    def int_at?(idx)
      /^\d+/.match?(self[idx].to_s)
    end

    def size
      chain.size
    end
  end
end
