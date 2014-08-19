module LLT
  class Review::Common
    class Reviewable
      include Core::Structures::HashContainable

      attr_reader :sentences

      def initialize(id, sentences)
        super(id)
        @sentences = sentences
      end

      # can't use the class methods that set the same, as we have
      # subclasses using this value as well
      def xml_tag
        :reviewable
      end

      def diff
        @container
      end

      def compare(gold, comparables = nil)
        comparison = Comparison.new(gold, self)
        comparison.compare(comparables)
        add(comparison)
      end

      def to_xml
        container_to_xml
      end
    end
  end
end
