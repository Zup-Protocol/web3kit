function Wallet() {
  this.isWalletInstalled = function (wallet) {
    return window[wallet] != null;
  };
}
