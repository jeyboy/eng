require 'rest-client'
require 'uri'

module Eng
  module Providers
    class IProvider
      protected
        class << self
          def eng_required?(request)
            request.gsub(/([\(\) _'\"]|[^[[:alpha:]]])+/, '')[0].try(:ord) < 512
          end

          # def urlencode(request)
          #   URI::escape(request)
          # end
        end
    end
  end
end