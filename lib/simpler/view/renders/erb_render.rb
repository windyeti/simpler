require 'erb'

module Simpler
  class View
    class Render
      class ErbRender
        def initialize(template_path)
          @template = File.read(template_path)
        end

        def result(binding)
          ERB.new(@template).result(binding)
        end
      end
    end
  end
end
