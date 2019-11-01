# frozen_string_literal: true

# Helper module with useful methods for RSpec
module SpecHelpers
  def parsed_response
    @parsed_response ||= JSON.parse(response.body, symbolize_names: true)
  end

  def body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
end
