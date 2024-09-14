function Ethers() {
  this.connectWallet = async function (provider) {
    var hasMultiNetworks;

    try {
      hasMultiNetworks = window[provider].ethereum !== undefined;
    } catch (_) {
      // do nothing
    }

    var walletProvider = new ethers.BrowserProvider(
      hasMultiNetworks ? window[provider].ethereum : window[provider]
    );

    await walletProvider.getSigner();
  };
}
