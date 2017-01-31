require 'nokogiri'

module Eng
  module Providers
    class Multitran < IProvider
      class << self
        def proc(request)
          response = RestClient::Request.execute(*request_attrs(request))
          p response.body
        end

      private
        def request_attrs(request)
          {
            timeout: 10,
            method: :get,
            url: 'http://www.multitran.com/m.exe',
            params: {
              s: urlencode(request)
            }.merge!(lang_sequence(request)),
            headers: {
              'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
              'DNT' => '1',
              'Host' => 'www.multitran.com'
            }
          }
        end

        def lang_sequence(request)
          l1, l2 = eng_required?(request) ? [1, 2] : [2, 1]
          {l1: l1, l2: l2}
        end
      end
    end
  end
end