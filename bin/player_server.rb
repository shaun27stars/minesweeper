$:.unshift File.expand_path("../../lib", __FILE__)
require "drb"
require "forwardable"
require "minesweeper/util"

module Minesweeper
  class PlayerServer
    include Minesweeper::Util
    extend Forwardable

    def initialize
      @player_class = find_player_classes.first
      @player = @player_class.new
    end

    def_delegators :@player, :name, :take_turn

    def stdin=(val)
      @player.stdin=val if @player.respond_to?(:stdin=)
    end

  end

  class ValidatingServer
    include DRbUndumped

    ValidationError = Class.new(RuntimeError)

    def initialize(secret, object, port)
      @secret = secret
      @object = object
      DRb.start_service "druby://0.0.0.0:#{port}", self
    end

    def method_missing(m, *args)
      validate!(args.shift)
      @object.__send__(m, *args)
    end

    def stop(secret)
      validate!(secret)
      DRb.stop_service
    end

  private
    def validate!(secret)
      raise ValidationError unless secret == @secret
    end
  end
end

lambda{ |path, port, secret|
  $:.unshift File.join(File.dirname(path), "lib")
  load path

  Minesweeper::ValidatingServer.new(
    secret, Minesweeper::PlayerServer.new, port
  )
}.call(*ARGV)

DRb.thread.join
