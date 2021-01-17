Feature: Wallet

    Check your portfolio's money in any currency.
    Every stocks are in USD by default.

    Scenario Outline: Return an error when target currency is not available
        Given a wallet containing stocks
            | type    | value    | shares  |
            | BTC/USD | 37540.00 | 0.06215 |
            | TLSA    | 826.16   | 3.2     |
            | PLTR    | 25.64    | 21      |
        And exchange rate for "<Currency>" does not exists
        When converting to "<Currency>"
        Then an error is returned
        And value should be null

        Examples:
            | Currency |
            | KEK      |
            | POG      |
            | CAT      |

    Scenario: Return an error when target currency is not available at exchangeratesapi.io
        Given a wallet containing stocks
            | type    | value    | shares  |
            | BTC/USD | 37540.00 | 0.06215 |
            | TLSA    | 826.16   | 3.2     |
            | PLTR    | 25.64    | 21      |
        And exchange rates are fetched from exchangeratesapi.io
        And exchange rate for "<Currency>" does not exists
        When converting to "<Currency>"
        Then an error is returned
        And value should be null

        Examples:
            | Currency |
            | KEK      |
            | POG      |
            | CAT      |

    Scenario Outline: Convert stocks to the target currency
        Given a wallet containing stocks
            | type    | value    | shares  |
            | BTC/USD | 37540.00 | 0.06215 |
            | TLSA    | 826.16   | 3.2     |
            | PLTR    | 25.64    | 21      |
        And USD to "<Currency>" rate is <Rate>
        When converting to "<Currency>"
        Then value should be <Value>
        And error should be null

        Examples:
            | Currency | Rate           | Value             |
            | EUR      | 0.8248783304   | 4549.420935156894 |
            | JPY      | 103.7202012703 | 572044.1884186385 |

    Scenario Outline: Convert stocks to the target currency using rates from exchangeratesapi.io
        Given a wallet containing stocks
            | type    | value    | shares  |
            | BTC/USD | 37540.00 | 0.06215 |
            | TLSA    | 826.16   | 3.2     |
            | PLTR    | 25.64    | 21      |
        And exchange rates are fetched from exchangeratesapi.io
        When converting to "<Currency>"
        Then value should not be null
        And error should be null

        Examples:
            | Currency |
            | EUR      |
            | JPY      |

    Scenario Outline: Convert an empty wallet
        Given a wallet containing stocks
            | type | value | shares |
        And USD to "<Currency>" rate is <Rate>
        When converting to "<Currency>"
        Then value should be <Value>
        And error should be null

        Examples:
            | Currency | Rate         | Value |
            | EUR      | 0.8248783304 | 0.00  |
