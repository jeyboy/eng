require 'eng/version'

require 'eng/providers/audio'

require 'eng/providers/multitran'
require 'eng/providers/google'

module Eng
  class << self
    def setup
      yield self
    end

    # def logger
    #   @@logger ||= Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
    # end

    def translate(request: nil, provider: :multitran)
      provider = providers[provider]

      status, response = provider && request && request.present? ? provider.proc(request) : [false, nil]

      {
        status: status,
        response: response
      }
    end

    def audio(request: nil)
      status, response = request && request.present? ? Providers::Audio::proc(request) : [false, nil]
    end

    private
      def providers
        {
          multitran: Providers::Multitran,
          google: Providers::Google
        }
      end
  end
end
