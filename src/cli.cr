require "./scroller"
require "option_parser"

module Scroller
  module Cli
    USAGE = "Usage: #{$0} [options] text"
    record Options, width, pause, mode, speed

    def parse_options
      width = 80
      pause = 0.seconds
      mode = nil
      speed = 4.0

      parser = OptionParser.new do |p|
        p.banner = USAGE

        p.on(
          "-wWIDTH", "--width WIDTH",
          "width of the scroller (default = 80)"
        ) do |input|
          width = input.to_i
        end

        p.on(
          "-pPAUSE", "--pause PAUSE",
          "pause length in seconds (default = 0)"
        ) do |input|
          pause = input.to_f.seconds
        end

        p.on(
          "-sSPEED", "--speed SPEED",
          "scrolling speed in 2/SPEED seconds (default = 4)"
        ) do |input|
          speed = input.to_f
        end

        p.on(
          "-mMODE", "--mode MODE",
          "mode of scroller, one of `rotate', `pong' or `rewind' " +
          "(defaults to rotate or pong depending on text length)"
        ) do |input|
          case(input)
          when "rotate" then mode = Mode::Rotate
          when "pong" then mode = Mode::Pong
          when "rewind" then mode = Mode::Rewind
          else abort(p)
          end
        end

        p.on("-h", "--help", "show this message") do
          puts p
          exit
        end
      end

      parser.parse!
      { Options.new(width, pause, mode, speed), parser.to_s }
    end

    def run
      options, help = parse_options
      text = ARGV[0]? || abort(help)
      scroller = Scroller.new(text, options.width, options.pause, options.mode)

      loop do
        puts scroller.to_s
        sleep(2 / options.speed)
      end
    end

    extend self
  end

  Cli.run
end

