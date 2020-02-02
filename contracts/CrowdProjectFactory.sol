pragma solidity >=0.5.0 <0.6.0;
/// @title A simulator for crowd sourcing and funding project factory
/// @author Fatin Alkinani
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
import './CrowdProject.sol';
import '../node_modules/@openzeppelin/contracts/math/SafeMath.sol';
import '../node_modules/@openzeppelin/contracts/ownership/Ownable.sol';

contract CrowdProjectFactory is Ownable {

    using SafeMath for uint256;

/// State Variables
////_________________
//// A state variable of for creating an indexed of the new created project
    uint256 private indexProject;
////A state variable to define the status of the contract: opetrated or not
     bool private operational;
//////Srtuctures
/////___________

/// A structure is used to define the project basic info that could be retrieved publicly
    struct ProjectBirthCertificate {
      uint256 PID;
      address admin;
      uint256 createdOn;
      CrowdProject contractAddress;
    }
    ///Lockups
    ///_______
    //// A mapping pointer to let each project id refer to the ProjectBirthCertificate
    mapping (uint256 => ProjectBirthCertificate) public ProjectsRegistry;

///Events
///___________
/** @notice This  event triggered when new project created

  */
    event ProjectCreated(uint256 PID, string name, address admin,uint maxNumContributers,string disciption, CrowdProject contractAddress);

/// an events will trigger when a donation of this contract withdrawn by the owner
    event DonationsWithdrawn(uint256 donations);

///Modifiers
///__________
/////isOperational is for checking the oprational state of this contract
    modifier isOperational() {
        require(operational == true, "This contract has been stopped by the owner.");
        _;
    }

///functions
///_____________
    /** @notice This constructor for initializing state variables of this contract

      */
    constructor ()
    public
    {
      indexProject=0;
      operational=true;
    }
    /** @notice Create Project
      * @dev Used for creating an independednt contract address for each project.
      * @param _name : .A project name.
      * @param _maxContributers s: .A max number of project required members.
      * @param _discription : A project describtion.
      */

    function createProject(string memory _name,  uint _maxContributers, string memory _discription )
        public
        payable
        isOperational() //isMember
       returns (CrowdProject newProject)
      {
        require (_maxContributers>=1);
        indexProject +=1;
        newProject = new CrowdProject( indexProject,msg.sender, _name, block.timestamp, _maxContributers, _discription);
        ProjectsRegistry[indexProject] = ProjectBirthCertificate(indexProject, msg.sender, block.timestamp, newProject);
        emit ProjectCreated(indexProject, _name, msg.sender, _maxContributers,_discription, newProject);
    }
    /** @notice This function called by frontend and by only owner of the contract
      * @dev Transfering all the money of the contract to its owneer.

      */

    function withdrawDonations()
        public
        onlyOwner()
    {
        require(address(this).balance > 0, "No donations to withdraw");
        uint256 donations = address(this).balance;
        msg.sender.transfer(donations);
        emit DonationsWithdrawn(donations);
    }
    /** @notice This function called by frontend.

      * @return the number of the registered projects.
      */
    function getProjectsCount() view
    public

    returns (uint)
    {
    return (indexProject);
    }
    /** @notice This function called by other functions
      * @dev It used to check the operational status of this contract
      * @return a flag refered that the operation status of this contract.
      */
    function getContractOperationSatus() view
    public

    returns (bool)
    {
    return (operational);
    }
    /** @notice This function called by only the owner
      * @dev It used to stop operations of this contact.
      */
    function shutdown()
        public
        onlyOwner()
    {
        operational = !operational;
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
