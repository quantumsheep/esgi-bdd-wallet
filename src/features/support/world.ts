import { setWorldConstructor } from "@cucumber/cucumber";
import axios from "axios";

export const STOCKS_CURRENCY = 'USD';
export const EXCHANGE_RATES_API = 'https://api.exchangeratesapi.io/latest?base=USD';

export interface Stock {
  type: string;
  value: number;
  shares: number;
}

class CurrencyNotFoundError extends Error {
  constructor(currency: string) {
    super(`Currency ${currency} is unknown by our service`)
  }
}

interface ExchangeRatesDTO {
  rates: Record<string, number>;
  base: string;
  date: string;
}

export class WalletWorld {
  private rates: Record<string, number> = {};

  private stocks: Stock[] = [];

  private value: number = null;
  private error: CurrencyNotFoundError = null;

  setStocks(stocks: Stock[]) {
    this.stocks = stocks;
  }

  async downloadRates() {
    const { data } = await axios.get<ExchangeRatesDTO>(EXCHANGE_RATES_API);
    this.rates = data.rates;
  }

  private resetConvertion() {
    this.value = null;
    this.error = null;
  }

  convert(currency: string) {
    const rate = (currency === STOCKS_CURRENCY) ? 1 : this.rates[currency];

    this.resetConvertion();

    if (rate === null || rate === undefined) {
      this.error = new CurrencyNotFoundError(currency);
    } else {
      this.value = this.stocks.reduce((acc, stock) => acc + (stock.value * stock.shares * rate), 0);
    }
  }

  getStocks(): readonly Stock[] {
    return this.stocks;
  }

  getError() {
    return this.error;
  }

  getValue() {
    return this.value;
  }

  getRates() {
    return this.rates;
  }

  setRate(currency: string, rate: number) {
    this.rates[currency] = rate;
  }
}

setWorldConstructor(WalletWorld);
