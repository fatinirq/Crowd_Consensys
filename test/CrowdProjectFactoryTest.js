const CrowdProjectFactory = artifacts.require("./CrowdProjectFactory.sol");

const EH = require("./exceptionsHelpers.js");
const BN = web3.utils.BN;
const toWei = web3.utils.toWei;

contract("CrowdProjectFactory", async accounts => {

  const _owner = accounts[0]
  const _admin1 = accounts[1]
  const _admin2 = accounts[2]

  let _name = "Project 1 Test"
  let _discription = "Crowd Funding and Sourcing Test"
  let instance

  beforeEach(async () => {
    instance = await CrowdProjectFactory.new({from:_owner});
  })

    it("Deploys succesfully and operational", async () => {
      let _operational = await instance.getContractOperationSatus.call({from: _owner})
      let _indexProject = await instance.getProjectsCount.call({from: accounts[9]})
      assert.equal((_operational, _indexProject), (true, 0), "Contract properly deployed or not operational");
    });

  //  it("It does N", async () => {
  //    await EH.catchRevert(instance.createProject(_name, _prize, {from: _admin1}));
  //  });

    it("Creates a new project when donations payed or not", async () => {
      await instance.createProject(_name,2,_discription, {from: _admin1, value: toWei("0.1", "ether")});
      let newP = await instance.ProjectsRegistry.call(1);
      assert.equal((newP['PID'], newP['admin']), (1, _admin1), "Project was not created properly");
      ///need to compare without payment
    });

    it("It reverts if Circuit Breaker is open (not operational)", async () => {
      await instance.shutdown({from: _owner});
      await EH.catchRevert(instance.createProject(_name,2,_discription, {from: _admin1, value: toWei("0.1", "ether")}));
    });

    it("Owner can withdraw funds generated from ProjectFactory initialization fees", async () => {
      await instance.createProject(_name,2,_discription, {from: _admin1, value: toWei("0.6", "ether")});
      await instance.createProject("Test Project 2", 20,"Created for test", {from: _admin2, value: toWei("0.4", "ether")});

      const preWithdrawAmount = await web3.eth.getBalance(_owner);
      let receipt = await instance.withdrawDonations({from: _owner});
      const postWithdrawAmount = await web3.eth.getBalance(_owner);

      let TXreceipt = await web3.eth.getTransaction(receipt.tx);
      let TXCost = Number(TXreceipt.gasPrice) * receipt.receipt.gasUsed;

      let expectedPostAmount = (new BN(preWithdrawAmount).add(new BN(toWei("1", "ether"))).sub(new BN(TXCost))).toString()

      assert.equal(postWithdrawAmount, expectedPostAmount)
    });

});
