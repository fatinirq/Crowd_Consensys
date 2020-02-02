App = {

  web3Provider: null,

  account: '0x0',
  contracts: {},
  init:  function() {
    window.alert("Zone1");


  //  return await App.initWeb3();
}
};
$(function() {
      window.alert("does not work");
      $(window).load(function() {
        App.init();
      });
    });
