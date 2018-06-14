require "eyeshade/balance"

module Eyeshade
  class Wallet
    attr_reader :action,
                :provider,
                :scope,
                :default_currency,
                :available_currencies,
                :possible_currencies,
                :contribution_balance,
                :channel_balances

    def initialize(wallet_json:, channel_json:)
      details_json = wallet_json["wallet"] || {}
      @authorized = details_json["authorized"]
      @provider = details_json["provider"]
      @scope = details_json["scope"]
      @default_currency = details_json["defaultCurrency"]
      @available_currencies = details_json["availableCurrencies"] || []
      @possible_currencies = details_json["possibleCurrencies"] || []

      status_json = wallet_json["status"] || {}
      @action = status_json["action"]

      balance_json = wallet_json["contributions"] || {}
      balance_json["rates"] = wallet_json["rates"] || {}

      @contribution_balance = Eyeshade::Balance.new(balance_json: balance_json)

      @channel_balances = {}
      channel_json.each do |identifier, json|
        @channel_balances[identifier] = Eyeshade::Balance.new(balance_json: json)
      end
    end

    def authorized?
      @authorized == true
    end
  end
end
