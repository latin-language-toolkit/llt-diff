module LLT
  class Diff::Parser::Report
    class Sentences < Generic
      include Diff::Parser::NoUniqueReportable

      def initialize(total = 1)
        super(:sentences, total)
      end
    end
  end
end

