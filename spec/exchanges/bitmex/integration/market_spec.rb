require 'spec_helper'

RSpec.describe 'Bitmex integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:xbt_usd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'XBT', target: 'USD', market: 'bitmex', inst_id: "XBTUSD" , contract_interval: "perpetual") }

  it 'fetch pairs' do
    pairs = client.pairs('bitmex')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'bitmex'
    expect(pair.contract_interval).to eq "monthly"
  end

  it 'fetch ticker' do
    ticker = client.ticker(xbt_usd_pair)

    expect(ticker.base).to eq 'XBT'
    expect(ticker.target).to eq 'USD'
    expect(ticker.market).to eq 'bitmex'
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
    expect(ticker.contract_interval).to eq "perpetual"
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url "bitmex", base: xbt_usd_pair.base, target: xbt_usd_pair.target, inst_id: xbt_usd_pair.inst_id
    expect(trade_page_url).to eq "https://www.bitmex.com/app/trade/XBTUSD"
  end

  it 'fetch order book' do
    order_book = client.order_book(xbt_usd_pair)

    expect(order_book.base).to eq 'XBT'
    expect(order_book.target).to eq 'USD'
    expect(order_book.market).to eq 'bitmex'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(xbt_usd_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'XBT'
    expect(trade.target).to eq 'USD'
    expect(trade.market).to eq 'bitmex'
    expect(trade.trade_id).to_not be_nil
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
  end

  it 'fetch contract stat' do
    contract_stat = client.contract_stat(xbt_usd_pair)

    expect(contract_stat.base).to eq 'XBT'
    expect(contract_stat.target).to eq 'USD'
    expect(contract_stat.market).to eq 'bitmex'
    expect(contract_stat.index).to be_a Numeric
    expect(contract_stat.open_interest).to be_a Numeric
    expect(contract_stat.timestamp).to be nil

    expect(contract_stat.payload).to_not be nil
  end
end
