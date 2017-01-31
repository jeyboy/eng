require 'rest-client'

module Eng
  module Providers
    class IProvider
      protected
        class << self
          def eng_required?(request) # test me
            request.gsub(/([\(\) _'\"]|[^a-zA-ZА-Яа-я])+/, '')[0] < 512
          end

          def urlencode(request) # test me
            URI::encode(request)
          end
        end
    end
  end
end