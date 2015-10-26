module Scroller
  enum Mode
    Rotate
    Pong
    Rewind
  end

  class Scroller
    def initialize(@text, @width, @pause = 0.seconds, @mode = nil : Mode?)
      @pos = 0
      @text_size = @text.size
      @mode = default_mode unless @mode
      @direction = 1
      if @mode == Mode::Rotate && @text_size > @width
        @text = { @text, @text[0, @text_size - @width - 2] }.join(" " * 2)
      end
    end

    def to_s
      result = @text[@pos, @width]
      return result if @text_size <= @width || Time.now - @pause < (@started ||= Time.now)

      case(@mode)
      when Mode::Rotate
        @pos = (@pos + 1) % (@text.size - @width + 1)
      when Mode::Pong
        @pos += @direction
        @direction *= -1 if @pos == 0 || @pos == @text_size - @width
      when Mode::Rewind
        @pos = (@pos + 1) % (@text_size - @width + 1)
        @started = nil if @pos == @text_size - @width
      end

      @started = nil if @pos == 0
      result
    end

    private def default_mode
      @width < (@text_size / 2) ? Mode::Rotate : Mode::Pong
    end
  end
end
