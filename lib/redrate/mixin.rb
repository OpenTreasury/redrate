# frozen_string_literal: true

module Redrate
  module Mixin
    def limit_method(method, rate:, interval: 60, redis:)
      queue = Queue.new(rate, redis, interval: interval, key: "#{self.name}##{method}")

      mixin = Module.new do
        define_method(method) do |*args|
          queue.shift
          super(*args)
        end
      end

      prepend mixin
    end
  end
end
