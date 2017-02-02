require 'rest-client'
require 'uri'

module Eng
  module Providers
    class IProvider
        class << self
          def proc(sentence)
            response = RestClient::Request.execute(request_attrs(sentence))
            prepared_answer(response.body)
          rescue RestClient::InternalServerError => e
            p e.response
          end

          protected

          def request_attrs(request)
            # stub
          end

          def prepared_answer(text)
            #stub
          end

          def eng_required?(sentence)
            sentence.gsub(/([\(\) _'\"]|[^[[:alpha:]]])+/, '')[0].try(:ord) < 512
          end

          def urlencode(request)
            URI::escape(request)
          end
        end
    end
  end
end