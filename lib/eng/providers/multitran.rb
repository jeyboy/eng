require 'nokogiri'
require 'eng/providers/iprovider'

module Eng
  module Providers
    class Multitran < IProvider
      class << self
        def proc(sentence)
          response = RestClient::Request.execute(request_attrs(sentence))
          prepared_answer(response.body)
        end

      private
        def prepare_suggestions(text)
          response = []

          /<a[^>]*>(.*?)<\/a>/.match(text) do |match|
            response << match
          end

          [false, {suggestions: response}]
        end

        def prepare_translations(html)
          translations = []
          translation = nil

          html.css('.left_col_mobile table').each do |table|
            break if table.has_attribute?('cellspacing')

            table.css('tr').each do |row|
              tds = row.css('td')

              if tds[0].has_attribute?('colspan')
                translations << translation if translation

                _, word, _, transcription, word_class = /\W([^<]+)<(span[^>]*>([^<]+)<\/span>[^<]*<)?em>([^<]+)</.match(tds[0].inner_html).to_a

                translation = {
                  word: word.strip,
                  transcription: transcription,
                  word_class: eng_types[word_class],
                  variants: []
                }
              else
                cleared_str = tds[1].inner_html.gsub(/(<span[^>]*>(.*?))( <a[^>]*>[^)]*)?(\))?(<\/span>)/) do |match|
                  if $2.include?('UserName=')
                    ''
                  else
                    "#{$2}#{$4}"
                  end
                end

                meanings = cleared_str.gsub(/\(?<a([^>]*)>(.*?)<\/a>\)?/, '\2').split(/ ?; ?/)
                meanings[-1] = meanings[-1].strip

                translation[:variants] << {
                  scope: tds[0].css('a')[0].inner_html,
                  meanings: meanings
                }
              end
            end
          end

          translations << translation if translation
          [true, translations]
        end

        def prepared_answer(text)
          suggest_start_pos = text.index('Suggest:')
          if suggest_start_pos
            end_pos = text.index(/<form|<table/, suggest_start_pos)
            prepare_suggestions(text[suggest_start_pos, end_pos - suggest_start_pos])
          else
            html = Nokogiri.parse(text)
            prepare_translations(html)
          end
        end

        def request_attrs(request)
          {
            timeout: 10,
            method: :get,
            url: 'http://www.multitran.com/m.exe',
            headers: {
              params: { s: request }.merge(lang_sequence(request)),
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

        def eng_types
          @eng_types ||= {
            'n' => 'noun',
            'v' => 'verb',
            'adj' => 'adjective',
            'adv' => 'adverb',
            'num' => 'numeral',
            'abbr' => 'abbreviation',
            'pron' => 'pronoun',
            # '' => 'noun plural',
            'prepos.' => 'preposition',
            'conj.' => 'conjunction'
          }
            # Adverblal  // Possessive
        end
      end
    end
  end
end