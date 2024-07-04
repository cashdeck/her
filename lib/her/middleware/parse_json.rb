module Her
  module Middleware
    class ParseJSON < Faraday::Response::Middleware

      # @private
      def parse_json(body = nil)
        body = '{}' if body.blank?

        json = begin
          JSON.parse(body, symbolize_names: true)
        rescue JSON::ParserError
          raise Her::Errors::ParseError, parse_json_error_message(body)
        end

        raise Her::Errors::ParseError, parse_json_error_message(body) unless json.is_a?(Hash) || json.is_a?(Array)

        json
      end

      private 

      # @private
      def parse_json_error_message(body)
        "Response from the API must behave like a Hash or an Array (last JSON response was #{body.inspect})"
      end
    end
  end
end
