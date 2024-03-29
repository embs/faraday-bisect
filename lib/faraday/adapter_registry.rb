# frozen_string_literal: true

require 'monitor'

module Faraday
  # AdapterRegistry registers adapter class names so they can be looked up by a
  # String or Symbol name.
  class AdapterRegistry
    def initialize
      @lock = Monitor.new
      @constants = {}
    end

    def get(name)
      klass = @constants[name]
      return klass if klass
      Object.const_get(name).tap { |klass| set(klass, name) }
    end

    def set(klass, name = nil)
      name ||= klass.to_s
      @lock.synchronize do
        @constants[name] = klass
      end
    end
  end
end
