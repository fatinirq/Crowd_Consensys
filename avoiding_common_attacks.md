# Avoiding Common Attacks
---

The creator of  Crowd Funding and Sourcing project has take the vulnerabilities seriously.   

## Re-entracy

The smart contracts don't interact with external smart contracts. Moreover, the credit-withdrawal design patterns was always used (as opposed to the force sending) as evidenced by the `withdrawDonations` function in the `CrowdProjectFactory` contract.

## Transaction Ordering and Timestamp Dependence

Timestamps are used only in the `CrowdProjectFactory` contract to set the `createdOn` property of the newly minted `CrowdProject` contracts when an externally owned account (EOA) calls the `createProject` function.

The `createdOn` property is rather unimportant. If miners were to manipulate it by a few seconds, no serious consequences would occur. As, it used only to register a project history

## Overflow and Underflow

OpenZeppelin's ```SafeMath.sol``` library was utilized. It can be found [here](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol).

## Denial of Service

The smart contracts don't interact with external smart contracts and when sending ether to EOAs the credit-withdrawal design pattern was used as evidenced in the
`DonationsWithdraw`  functions.

## Denial of Service by Block Gas Limit (or startGas)

To prevent this attack, no while nor for loops were utilized.

## Force Sending Ether

To prevent this attack, no core logic is based upon the contract's balance. Moreover, the credit-withdraw pattern was always preferred in place of force sending.

## Roles

Privileges of (Admin, Owner,Member ) were implement as embedded roles in the `Crowd Sourcing and Sourcing` contracts to control who calls them.  Modifiers are checking the appropriate privileges were added to all relevant functions;

###To Do:
State management and upgradable design are planed to be applied.

#### Examples of how Fatin avoided possible problems:

#Example 1

Insecured
**************
If the message sender is already enrolled then the function could update lookups and increment  membersCount.  This could lead the contract to present update registered member data unintentionally which leads to consume transaction fee. Also, it will falsify the no. of member value.
function storeMemebr(string memory firstNameMember,string memory lastNameMember, string memory emailMember) public
{


  CrowdStructure.MemberData memory member;
  member.firstName=firstNameMember;
  member.lastName= lastNameMember;

  member.email=emailMember;
  //member.phonNo= phonNoMember;
  //member.nationality=nationalityMember;
  members[msg.sender]=member;
  enrolledMembers[msg.sender]=true;
  membersCount+=1;
  emit LogEnrolled(msg.sender);


//  txID=keccak256(abi.encodePacked(index2,msg.sender));

}

Secured
************
function storeMemebr(string memory firstNameMember,string memory lastNameMember, string memory emailMember) public returns(bool)
{

if(enrolledMembers[msg.sender]==false)
{
  CrowdStructure.MemberData memory member;
  member.firstName=firstNameMember;
  member.lastName= lastNameMember;

  member.email=emailMember;

  members[msg.sender]=member;
  enrolledMembers[msg.sender]=true;
  membersCount+=1;
  emit LogEnrolled(msg.sender);
}
return enrolledMembers[msg.sender];

//  txID=keccak256(abi.encodePacked(index2,msg.sender));

}

##Example 2

Inconvenient
*********


It will notify unregistered visitor with a projID

 function createProject(string memory discription, string memory name) public returns (uint prjID)
 {


     CrowdStructure.MemberData memory data= members[msg.sender];
     CrowdStructure.Project memory prj;
     prj.projectName=name;
     prj.projectDiscrption=discription;
     CrowdProject prj= (new CrowdProject());
     indexProjects++;
     projects[indexProjects]=prj;
     projects[indexProjects].staff[msg.sender]= CrowdStructure.ProjectMember ({adr:msg.sender,data:data,cont:CrowdStructure.Contribution.Owner}) ;
     ownerToProjects[msg.sender].count ++;
     uint index = ownerToProjects[msg.sender].count;
     ownerToProjects[msg.sender].idToProject[index]=indexProjects;
     prjID=indexProjects;

     //txID=keccak256(abi.encodePacked(index2,msg.sender));

 }

 Convenient
 ***********

 function createProject(string memory discription, string memory name) public returns (uint prjID)
 {

   if (enrolledMembers[msg.sender]==true)
   {
     CrowdStructure.MemberData memory data= members[msg.sender];
     CrowdStructure.Project memory prj;
     prj.projectName=name;
     prj.projectDiscrption=discription;
     CrowdProject prj= (new CrowdProject());
     indexProjects++;
     projects[indexProjects]=prj;
     projects[indexProjects].staff[msg.sender]= CrowdStructure.ProjectMember ({adr:msg.sender,data:data,cont:CrowdStructure.Contribution.Owner}) ;
     ownerToProjects[msg.sender].count ++;
     uint index = ownerToProjects[msg.sender].count+1;
     ownerToProjects[msg.sender].idToProject[index]=indexProjects;
     prjID=indexProjects;

     //txID=keccak256(abi.encodePacked(index2,msg.sender));
 }
 }
