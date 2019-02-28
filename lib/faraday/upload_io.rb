# frozen_string_literal: true

begin
  require 'composite_io'
  require 'parts'
  require 'stringio'
rescue LoadError
  $stderr.puts 'Install the multipart-post gem.'
  raise
end

module Faraday
  # Similar to, but not compatible with [::CompositeReadIO](https://github.com/nicksieger/multipart-post/blob/master/lib/composite_io.rb) provided by [multipart-post](https://github.com/nicksieger/multipart-post).
  class CompositeReadIO
    def initialize(*parts)
      @parts = parts.flatten
      @ios = @parts.map { |part| part.to_io }
      @index = 0
    end

    # @return [Integer] sum of the lengths of all the parts
    def length
      @parts.inject(0) { |sum, part| sum + part.length }
    end

    # Rewind each of the IOs and reset the index to 0.
    #
    # @return [void]
    def rewind
      @ios.each { |io| io.rewind }
      @index = 0
    end

    # Read from IOs in order until `length` bytes have been received.
    #
    # @param length [Integer, nil]
    # @param outbuf [String, nil]
    def read(length = nil, outbuf = nil)
      got_result = false
      outbuf = outbuf ? (+outbuf).replace('') : +''

      while (io = current_io)
        if (result = io.read(length))
          got_result ||= !result.nil?
          result.force_encoding('BINARY') if result.respond_to?(:force_encoding)
          outbuf << result
          length -= result.length if length
          break if length == 0
        end
        advance_io
      end
      !got_result && length ? nil : outbuf
    end

    # Close each of the IOs.
    #
    # @return [void]
    def close
      @ios.each { |io| io.close }
    end

    def ensure_open_and_readable
      # Rubinius compatibility
    end

    private

    def current_io
      @ios[@index]
    end

    def advance_io
      @index += 1
    end
  end

  UploadIO = ::UploadIO
  Parts = ::Parts
end
