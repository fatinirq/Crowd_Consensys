

Unsecures
**************
If the message sender is already enrolled then the function could update lookups and increment  membersCount.  This could lead the contract to present update registered member data unintentionally which leads to consume transaction fee. Also, it will falsify the no. of member value.
function storeMemebr(string memory _firstNameMember,string memory _lastNameMember, string memory _emailMember) public
{


  CrowdStructure.MemberData memory _member;
  _member.firstName=_firstNameMember;
  _member.lastName= _lastNameMember;
  //member.skills=_skillsMember ;
  _member.email=_emailMember;
  //member.phonNo= _phonNoMember;
  //member.nationality=_nationalityMember;
  members[msg.sender]=_member;
  enrolledMembers[msg.sender]=true;
  membersCount+=1;
  emit LogEnrolled(msg.sender);


//  txID=keccak256(abi.encodePacked(index2,msg.sender));

}
Secured
************
function storeMemebr(string memory _firstNameMember,string memory _lastNameMember, string memory _emailMember) public returns(bool)
{

if(enrolledMembers[msg.sender]==false)
{
  CrowdStructure.MemberData memory _member;
  _member.firstName=_firstNameMember;
  _member.lastName= _lastNameMember;
  //member.skills=_skillsMember ;
  _member.email=_emailMember;
  //member.phonNo= _phonNoMember;
  //member.nationality=_nationalityMember;
  members[msg.sender]=_member;
  enrolledMembers[msg.sender]=true;
  membersCount+=1;
  emit LogEnrolled(msg.sender);
}
return enrolledMembers[msg.sender];

//  txID=keccak256(abi.encodePacked(index2,msg.sender));

}
Inconvenient
*********


It will notify unregistered visitor with a projID

 function createProject(string memory _discription, string memory _name) public returns (uint prjID)
 {


     CrowdStructure.MemberData memory _data= members[msg.sender];
     CrowdStructure.Project memory _prj;
     _prj.projectName=_name;
     _prj.projectDiscrption=_discription;
     CrowdProject prj= (new CrowdProject());
     indexProjects++;
     projects[indexProjects]=_prj;
     projects[indexProjects].staff[msg.sender]= CrowdStructure.ProjectMember ({adr:msg.sender,data:_data,cont:CrowdStructure.Contribution.Owner}) ;
     ownerToProjects[msg.sender].count ++;
     uint index = ownerToProjects[msg.sender].count;
     ownerToProjects[msg.sender].idToProject[index]=indexProjects;
     prjID=indexProjects;

     //txID=keccak256(abi.encodePacked(index2,msg.sender));

 }

 Convenient
 ***********

 function createProject(string memory _discription, string memory _name) public returns (uint prjID)
 {

   if (enrolledMembers[msg.sender]==true)
   {
     CrowdStructure.MemberData memory _data= members[msg.sender];
     CrowdStructure.Project memory _prj;
     _prj.projectName=_name;
     _prj.projectDiscrption=_discription;
     CrowdProject prj= (new CrowdProject());
     indexProjects++;
     projects[indexProjects]=_prj;
     projects[indexProjects].staff[msg.sender]= CrowdStructure.ProjectMember ({adr:msg.sender,data:_data,cont:CrowdStructure.Contribution.Owner}) ;
     ownerToProjects[msg.sender].count ++;
     uint index = ownerToProjects[msg.sender].count+1;
     ownerToProjects[msg.sender].idToProject[index]=indexProjects;
     prjID=indexProjects;

     //txID=keccak256(abi.encodePacked(index2,msg.sender));
 }
 }
