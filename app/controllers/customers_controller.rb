# frozen_string_literal: true

class CustomersController < ApplicationController
  def index
    @customers = CustomersQuery.new(params).results
  end
end

