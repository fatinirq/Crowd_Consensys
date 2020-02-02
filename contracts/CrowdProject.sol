pragma solidity >=0.5.0 <0.6.0;
/// @title A simulator for crowd sourcing and funding members and projects
/// @author Fatin Alkinani
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
pragma experimental ABIEncoderV2;
import "./CrowdStructure.sol";
import "./CrowdMember.sol";

/** @title Crowd Project: used to create a seperated contract for each crowd member want to register and collect team for it
in the crowd. It is initialized and deployed by the main contract of CrowdProjectFactory
  */
 contract CrowdProject
 {

//state variables
CrowdStructure.Project  prj;

/** @notice This constructor for initializing the project state variable called
  * @dev Creating a new instance of contract by CrowdProjectFactory contract.
   All the parameters are given by the CrowdProjectFactory contract.
  * @param _PID : A project Id, given by the CrowdProjectFactory.
  * @param _admin : .A project admin address.
  * @param _name : .A project name.
  * @param _createdOn : .A project date of creation.
  * @param _maxContributers : .A max number of project required members.
  * @param _discription : A project describtion.
  */
constructor(uint _PID,  address _admin, string memory _name, uint256 _createdOn, uint256 _maxContributers, string memory _discription) public
{

    prj.PID=_PID;
    prj.admin=_admin;
    prj.projectName=_name;
    prj.projectDiscrption=_discription;
    prj.maxContributers=_maxContributers;
    prj.noContributers=1;
    prj.staff[msg.sender]=CrowdStructure.ProjectMember ({adr:msg.sender,cont:CrowdStructure.Contribution.Admin}) ;
  //  emit LogProject(_admin);


}
// a modifier is used to check if the sender is admin or not
modifier isAdmin()
{
  require(msg.sender==getAdmin(),"only admin");
  _;
}
/// A modifier to check if the project can accept new members or not.
modifier isOpen()
{
  require(prj.maxContributers>prj.noContributers, "This project is not accept new contributer");
  _;
}

/// This function is a pending work for future steps
modifier isCrowdMember()
{
  address _adr=msg.sender;

  //require(CrowdMember.getEnrolledAddress[_adr]==true);
  _;
}

/** @notice  This functon is planed to be exploited in the next step.
  * @dev    It is used if the caller is the project admin or not. .
  *
  * @return  the address of the admin.
  */
function getAdmin()
view
public
returns(address)
{
  return(prj.admin);
}
/** @notice  This functon is planed to be exploited in the next step.
  * @dev    It is used to transfer the funds to the project contract
  */
 function fundProject() public payable
 {
   require (msg.sender.balance>= msg.value, "The sent value is less than the sender balance");
   address(this).transfer(msg.value);

 }

 /** @notice  This functon is planed to be exploited in the next step.
   * @dev     It is used to add new member to the project.
   * @return  the address of the admin.
   */
 function joinProject(CrowdStructure.Contribution _cont)
  public
  isOpen

 {
     prj.staff[msg.sender]=CrowdStructure.ProjectMember ({adr:msg.sender,cont:_cont}) ;

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
