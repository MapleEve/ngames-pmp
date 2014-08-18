module OAuth2
  class Error < StandardError
    attr_reader :response, :code, :description

    # standard error values include:
    # :invalid_request, :invalid_client, :invalid_token, :invalid_grant, :unsupported_grant_type, :invalid_scope
    def initialize(response)
      response.error = self
      @response = response

      message = []

      if response.parsed.is_a?(Hash) && response.parsed['code'] > 0
        @code = response.parsed['code']
        @description = response.parsed['message']
        message << "#{@code}: #{@description}"
      end

      message << response.body

      super(message.join("\n"))
    end
  end
end
