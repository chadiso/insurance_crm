# frozen_string_literal: true

class ImportsQuery
  PER_PAGE = 10

  attr_reader :params, :relation

  def initialize(params)
    @params = params
    @relation = Import.all
  end

  def results
    scoped = relation

    scoped = scoped.order(created_at: :desc)
    scoped = scoped.paginate(pagination_params)

    scoped
  end

  private

  def pagination_params
    {
      page: page_sanitized,
      per_page: PER_PAGE
    }
  end

  def page_sanitized
    page = params[:page].to_i
    page.positive? ? page : 1
  end
end
