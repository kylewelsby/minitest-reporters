module Minitest
  module Reporters
    class GithubReporter < BaseReporter
      def record(test)
        super

        type = determine_type(test)
        output = create_output(test)
        message = test.failure

        puts "#{type} #{output.join(',')}::#{message}"
      end

      private

      def determine_type(test)
        if test.skipped?
          "::notice"
        elsif test.error? || test.failure
          "::error"
        end
      end

      def create_output(test)
        {
          file: relative_path(test.source_location[0]),
          line: test.source_location[1],
          title: test.name,
        }.map { |k, v| "#{k}=#{escape_properties(v)}" }
      end

      def relative_path(path)
        Pathname.new(path).relative_path_from(Pathname.new(Dir.getwd))
      end

      def escape_properties(string)
        string.to_s.gsub("%", '%25')
              .gsub("\r", '%0D')
              .gsub("\n", '%0A')
              .gsub(":", '%3A')
              .gsub(",", '%2C')
      end
    end
  end
end
