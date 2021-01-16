Feature: Wallet

    Check your portfolio's money in any currency.
    Every stocks are in USD by default.

    Rule: Return an error when target currency is not available
        Example: Converting to KEK
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            When converting to "KEK"
            Then an error is returned
            And value should be null

        Example: Converting to POG
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            When converting to "POG"
            Then an error is returned
            And value should be null

        Example: Converting to CAT using exchangeratesapi.io
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            And exchange rates fetched from exchangeratesapi.io
            When converting to "CAT"
            Then an error is returned
            And value should be null

    Rule: Return 0 when the wallet is empty
        Example: Converting to EUR
            Given a wallet containing 0 stocks
                | type | value | shares |
            And USD to "EUR" rate is 0.8248783304
            When converting to "EUR"
            Then value should be 0.00
            And error should be null

    Rule: Convert each stocks to the target currency
        Example: Converting to EUR
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            And USD to "EUR" rate is 0.8248783304
            When converting to "EUR"
            Then value should be 4549.420935156894
            And error should be null

        Example: Converting to JPY
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            And USD to "JPY" rate is 103.7202012703
            When converting to "JPY"
            Then value should be 572044.1884186385
            And error should be null

        Example: Converting to JPY using exchangeratesapi.io
            Given a wallet containing 3 stocks
                | type    | value    | shares  |
                | BTC/USD | 37540.00 | 0.06215 |
                | TLSA    | 826.16   | 3.2     |
                | PLTR    | 25.64    | 21      |
            And exchange rates fetched from exchangeratesapi.io
            When converting to "JPY"
            Then value should not be null
            And error should be null
