# encoding: utf-8

require "stringio"
require "colored"

module Minesweeper
  class ConsoleRenderer
    RESET = "\e[2J\e[H"

    def render(game)
      output = StringIO.new(buffer = "")
      name   = game.name
      report = game.report

      output << RESET
      render_player(output, name, report)
      output.puts

      buffer
    end

  private
    ICONS = {
      :unknown => ". ",
      :mine    => "X ",
      :flag    => '~ '
    }

    def render_row(row)
      row.map{ |name| icon(name) }.join
    end

    def icon(name)
      ICONS[name] || name
    end

    def render_player(output, name, board)
      output.puts name, ""

      board.each do |row|
        output << render_row(row)
        output.puts
      end
    end
  end

  class DeluxeConsoleRenderer < ConsoleRenderer

    ICONS = {
      :unknown => "· ",
      :mine    => "█ ".red,
      :flag    => "█ ".green
    }

  private
    def icon(name)
      ICONS[name] || "#{name} "
    end

  end
end
