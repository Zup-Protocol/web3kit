function Ethers() {
  this.connectWallet = async function (provider) {
    var hasMultiNetworks = window[provider].ethereum !== undefined;
    console.log(hasMultiNetworks);

    var walletProvider = new ethers.BrowserProvider(
      hasMultiNetworks ? window[provider].ethereum : window[provider]
    );
    return await walletProvider.getSigner();
  };
}
