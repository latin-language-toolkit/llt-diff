module LLT
  class Diff::Parser
    class Word
      include HashContainable

      attr_accessor :form, :lemma, :postag, :head, :relation
    end
  end
end
