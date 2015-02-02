require "rstreet/version"

module Rstreet
  class Debug

    def initialize(options)
      @options = options
    end

    def hello
      @options.to_h.each do |k, v|
        puts "#{k} => #{v}"
      end
      puts "Rstreet time!"
    end
  end
end
