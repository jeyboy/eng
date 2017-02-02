require 'eng/providers/iprovider'

module Eng
  module Providers
    class Google < IProvider
      class << self
        private
        def request_attrs(request)
          {
            timeout: 10,
            method: :post,
            url: 'https://www.google.com.ua/async/translate?client=firefox-b&yv=2',
            headers: {
              # params: { client: 'firefox-b', yv: 2 },
              'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
              'DNT' => '1',
              'Host' => 'www.google.com.ua',
              'Referer' => 'https://www.google.com.ua/',
              'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:48.0) Gecko/20100101 Firefox/48.0")'
            },
            payload: payload(request),
            content_type: 'application/x-www-form-urlencoded;charset=utf-8'
          }
        end

        def prepared_answer(text)
          json = JSON::parse(text)
          i = 0
        end

        def payload(request)
          "async=translate,#{lang_sequence(request)},st:#{urlencode(request)},id:14800615#{rand(11111..99999)},qc:true,ac:true,_id:tw-async-translate,_pms:s"
        end

        def lang_sequence(request)
          eng_required?(request) ? 'sl:en,tl:ru' : 'sl:ru,tl:en'
        end
      end
    end
  end
end