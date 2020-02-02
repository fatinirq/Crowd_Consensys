

let catchRevert = require("./exceptionsHelpers.js").catchRevert
var Crowds = artifacts.require("./CrowdMember.sol")

contract('CrowdMember', function(accounts) {

  const owner = accounts[0]
  const alice = accounts[1]
  const bob = accounts[2]



  beforeEach(async () => {
    instance = await Crowds.new()
  })
/// test of enrollment


it("should not mark unenrolled users as enrolled", async() =>{
  const aliceEnrolled = await instance.enrolled(alice, {from: alice})

    //const aliceEnrolled = await instance.enrolledMembers(alice, {from: alice})
    assert.equal(aliceEnrolled, false, 'only enrolled users should be marked enrolled')
  })

  it("It should  mark enrolled users as enrolled", async() =>{
      await instance.storeMember("Fatin","Alkinani","test@test.com",{from: alice})
      const aliceEnrolled = await instance.enrolled(alice, {from: alice})

      assert.equal(aliceEnrolled, true, 'only enrolled users should be marked enrolled')
    })
  it(" It should retrieve member correctly", async() =>{
      const flag=await instance.storeMember("Fatin","Alkinani","test@test.com",{from:bob})
      const memberData= await instance.getMember({from:bob})
      console.log(memberData[0])
      const bobEnrolled = await instance.enrolled(bob, {from: bob})
      //instance.createProject(memberData[0],memberData[1],memberData[2])
    //  assert.equal(aliceEnrolled, true, 'only enrolled users should be marked enrolled')
    })
/// test if the project creator is enrolled
 


})
