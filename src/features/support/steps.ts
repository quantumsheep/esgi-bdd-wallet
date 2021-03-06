import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { strict as assert } from 'assert';
import { Stock, WalletWorld } from './world';

interface DataTableGeneric<T> extends DataTable {
  hashes(): T[];
}

Given('a wallet containing stocks', function (this: WalletWorld, stocks: DataTableGeneric<Stock>) {
  this.setStocks(stocks.hashes());
});

Given('USD to {string} rate is {float}', function (this: WalletWorld, currency: string, rate: number) {
  this.setRate(currency, rate);
});

Given('exchange rate for {string} does not exists', function (this: WalletWorld, currency: string) {
  this.removeRate(currency);
});

When('converting to {string}', function (this: WalletWorld, currency: string) {
  this.convert(currency);
});

Then('an error is returned', function (this: WalletWorld) {
  const error = this.getError();

  assert.notEqual(error, null);
  assert.notEqual(error, undefined);
});

Then('error should be {string}', function (this: WalletWorld, expectedError: string) {
  const error = this.getError();
  assert.equal(error.message, expectedError);
});

Then('value should be {float}', function (this: WalletWorld, expectedValue: number) {
  const value = this.getValue();
  assert.equal(value, expectedValue);
});
