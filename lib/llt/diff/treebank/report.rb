module LLT
  class Diff::Treebank
    class Report
      require 'llt/diff/treebank/report/generic'
      require 'llt/diff/treebank/report/datapoints'
      require 'llt/diff/treebank/report/sentences'
      require 'llt/diff/treebank/report/postags'
      require 'llt/diff/treebank/report/lemma'
      require 'llt/diff/treebank/report/postag'
      require 'llt/diff/treebank/report/postag/datapoint'
      require 'llt/diff/treebank/report/relation'

      include Diff::Helpers::Reportable

      attr_reader :sentences

      def initialize(id, sentences)
        super(id)
        @sentences = sentences
      end

      def report
        @report ||= begin
          add_report_container
          if RUBY_ENGINE == 'jruby'
            collect_multithreaded
          else
            collect_singlethreaded
          end
          @container.each { |_, rep| rep.sort! }
        end
      end

      def collect_singlethreaded
        @sentences.map { |_, s| s.report }.each do |rep|
          rep.each { |_, r| add(r) }
        end
      end

      def collect_multithreaded
        slice_size = @sentences.size / 4
        slice_size = 1 if slice_size.zero?
        threads = []
        @sentences.each_slice(slice_size) do |slice|
          temp_container = Report.new(nil, {})
          threads << Thread.new do
            slice.map { |_, s| s.report }.each do |rep|
              rep.each { |_, r| temp_container.add(r) }
            end
            temp_container
          end
        end
        temps = threads.flat_map { |t| t.join; t.value }
        temps.each { |temp| temp.each { |_, r| add(r) }}
      end

      def xml_attributes
        { id: @id }
      end

      private

      def add_report_container
        add(Sentences.new(@sentences.count))
      end
    end
  end
end