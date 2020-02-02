pragma solidity >=0.5.0 <0.6.0;
/// @title A simulator for crowd sourcing and funding members and projects
/// @author Fatin Alkinani
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
pragma experimental ABIEncoderV2;
import "./CrowdStructure.sol";

/** @title Crowd Member  */
 contract CrowdMember
 {
constructor()public
{

  deployed=address(this);

}

//State variables

uint  membersCount ;//setting a counter of al members
//bytes32 public txID ;
uint   indexProjects;//unused, palnned for the next step

address private deployed ;
////Lockups
///_____
// mapping address to CrowdMember
mapping (address=>CrowdStructure.MemberData) private members;
//Marking members  after success registeration
mapping (address=>bool) private enrolledMembers;

mapping (address=>CrowdStructure.Project)private projects ;///planned for the next step

/////Lockup between member adress and his projects
mapping (address=>address) private ownerToProjects;

///Modifiers
modifier isEnrolled()
{
  require (enrolledMembers[msg.sender]==true);
  _;
}
////*events*///
event LogEnrolled(address indexed accountAddress);

//functions
//_________
 function getEnrolledAddress(address _address) view public returns(bool)
  {
    return enrolledMembers[_address];
    }

  /** @notice This function called by frontend to pass the parameters and register new memebr
    * @dev Storing  member data in enrolled and members
    * @param _firstNameMember : First Name of the member
    * @param _lastNameMember : Last name of the member
    * @param _emailMember : email of the member 
    * @return a flag refered that the member enrolled succefflly.
    */

function storeMember(string memory _firstNameMember,string memory _lastNameMember, string memory _emailMember)
public
returns(bool)
{


  CrowdStructure.MemberData memory _member;
  _member.firstName=_firstNameMember;
  _member.lastName= _lastNameMember;
  _member.email=_emailMember;
////

  members[msg.sender]=_member;

  enrolledMembers[msg.sender]=true;
  membersCount+=1;
  emit LogEnrolled(msg.sender);

return enrolledMembers[msg.sender];

//  txID=keccak256(abi.encodePacked(index2,msg.sender));

}
/** @notice This function called by  user interface to get info of specific member
  * @dev Retrieving  member data in enrolled and members lookups.

  * @return Data of msg.sender .
  */


 function  enrolled()  public view returns  (bool)
 {
return (enrolledMembers[msg.sender]);
 }
/** @notice This function called by  user interface to get info of specific member
  * @dev Retrieving  member data from enrolled and members lookups.

  * @return Data of msg.sender .
  */


  function  getMember()  public view isEnrolled returns  (CrowdStructure.MemberData memory )
 {

   return (members[msg.sender]);

 }



 /** @notice This function called by  user interface to get info of specific member
   * @return tempCount The counted members of the contracts .
   */

 function getMemeberCount() public view returns (uint tempCount)
 {
    tempCount=membersCount;
    return tempCount;
 }



 // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () external payable {
        revert();
    }

}
