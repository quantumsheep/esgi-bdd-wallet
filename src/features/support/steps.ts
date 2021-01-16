import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { strict as assert } from 'assert';
import { Stock, WalletWorld } from './world';

interface DataTableGeneric<T> extends DataTable {
  hashes(): T[];
}

Given('a wallet containing {int} stocks', function (this: WalletWorld, stocks_count: number, stocks: DataTableGeneric<Stock>) {
  this.setStocks(stocks.hashes());
});

Given('USD to {string} rate is {float}', function (this: WalletWorld, currency: string, rate: number) {
  this.setRate(currency, rate);
});

Given('exchange rates fetched from exchangeratesapi.io', async function (this: WalletWorld) {
  await this.downloadRates();
});

When('converting to {string}', function (this: WalletWorld, currency: string) {
  this.convert(currency);
});

Then('an error is returned', function (this: WalletWorld) {
  const error = this.getError();

  assert.notEqual(error, null);
  assert.notEqual(error, undefined);
});

Then('error should be null', function (this: WalletWorld) {
  const error = this.getError();
  assert.equal(error, null);
});

Then('value should be null', function (this: WalletWorld) {
  const value = this.getValue();
  assert.equal(value, null);
});

Then('value should not be null', function (this: WalletWorld) {
  const value = this.getValue();
  assert.notEqual(value, null);
  assert.notEqual(value, undefined);
});

Then('value should be {float}', function (this: WalletWorld, expectedValue: number) {
  const value = this.getValue();
  assert.equal(value, expectedValue);
});
