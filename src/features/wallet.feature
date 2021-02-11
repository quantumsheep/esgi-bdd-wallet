Feature: Wallet

    Check your portfolio's money in any currency.
    Every stocks are in USD by default.

    Scenario Outline: Return an error when target currency is not available
        Given a wallet containing stocks
            | type    | value | shares |
            | BTC/USD | 10000 | 0.01   |
            | TLSA    | 1000  | 3.2    |
            | PLTR    | 50    | 20     |
        And exchange rate for "POG" does not exists
        When converting to "POG"
        Then error should be "Currency POG is unknown by our service"

    Scenario Outline: Convert stocks to the target currency
        Given a wallet containing stocks
            | type    | value   | shares |
            | BTC/USD | 10000   | 1      |
            | TLSA    | 1000.30 | 2.5    |
        And USD to "<Currency>" rate is <Rate>
        When converting to "<Currency>"
        Then value should be <Value>

        Examples:
            | Currency | Rate | Value      |
            | EUR      | 0.8  | 10000.60   |
            | JPY      | 100  | 1250075.00 |

    Scenario Outline: Convert an empty wallet
        Given a wallet containing stocks
            | type | value | shares |
        And USD to "<Currency>" rate is <Rate>
        When converting to "<Currency>"
        Then value should be <Value>

        Examples:
            | Currency | Rate | Value |
            | EUR      | 0.8  | 0.00  |
