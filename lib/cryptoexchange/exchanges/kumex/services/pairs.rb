module Cryptoexchange::Exchanges
  module Kumex
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Kumex::Market::API_URL}/contracts/active"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          pairs = []
          output['data'].each do |data|
            base, target = data['baseCurrency'], data['quoteCurrency']
            pairs << Cryptoexchange::Models::MarketPair.new(
                base: base,
                target: target,
                contract_interval: 'perpetual',
                inst_id: data['symbol'],
                market: Kumex::Market::NAME
              )
          end
          pairs
        end
      end
    end
  end
end
