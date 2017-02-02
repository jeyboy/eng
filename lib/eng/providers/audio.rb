module Eng
  module Providers
    class Audio
      class << self
        def proc(sentence)
          sentence.split(' ').each_with_object({}) do |word, res|
            res[word] = "http://www.gstatic.com/dictionary/static/sounds/de/0/#{word.downcase}.mp3"
          end
        end
      end
    end
  end
end