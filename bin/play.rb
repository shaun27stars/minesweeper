$:.unshift File.expand_path("../../lib", __FILE__)
require "minesweeper/game"
require "minesweeper/console_renderer"
require "minesweeper/util"
require "stringio"
require "digest/sha1"
require "forwardable"
require "drb"

DELAY = 0.2
PORT = 4432

class PlayerClient
  extend Forwardable

  def initialize(secret, object)
    @secret = secret
    @object = object
  end

  def method_missing(m, *args)
    args.unshift(@secret)
    @object.__send__(m, *args)
  end

  def kill
    @object.stop(@secret)
  end
end

begin
  DRb.start_service

  player_server = File.expand_path("../player_server.rb", __FILE__)

  path = ARGV[0]
  port = PORT
  secret = Digest::SHA1.hexdigest("#{Time.now}#{rand}")
  system %{ruby #{player_server} "#{path}" #{port} #{secret} &}
  Minesweeper::Util.wait_for_socket('0.0.0.0', port)
  player = PlayerClient.new(secret, DRbObject.new(nil, "druby://0.0.0.0:#{port}"))
  player.stdin = $stdin

  stderr = ""
  $stderr = StringIO.new(stderr)

  game = Minesweeper::Game.new(player)
  renderer = Minesweeper::DeluxeConsoleRenderer.new
  $stdout << renderer.render(game)
  $stdout << stderr

  until game.game_over
    t0 = Time.now
    game.tick
    time_taken = Time.now - t0
    $stdout << renderer.render(game)
    $stdout << stderr
    sleep [DELAY - time_taken, 0].max
  end

  puts "", "You #{game.game_over}!"

  player.kill

rescue Exception => e
  $stderr = STDERR
  raise e
ensure
  player.kill
end
