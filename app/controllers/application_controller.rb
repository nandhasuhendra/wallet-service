class ApplicationController < ActionController::API
  include ErrorException
  if ENV["DISABLE_QUERY_CACHE"] == 'true'
    around_action :disable_query_cache

    def disable_query_cache
      ActiveRecord::Base.uncached do
        yield
      end
    end
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end
end
