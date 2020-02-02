pragma solidity >=0.5.0 <0.6.0;
 library CrowdStructure
 {
   enum   Contribution{
      Owner
      ,Admin
     , Consultatnt
     ,Skilled
     //Investor
   }
   struct  MemberData {


   string firstName;
   string lastName;
   //string idNo;
   //address admin;
   //string skills;
   string email;
   //string phonNo;
   //string website;
   //string nationality;
   //string country;
   //string city;
   //string addressLine;
   }
   struct ProjectMember
   {
     address adr;
     Contribution cont;

   }
   /// Project Modelling
   struct Project
   {
    uint PID;
    address admin;
    string projectDiscrption;
    string projectName;
    uint maxContributers;
    uint noContributers;
    mapping (address=>ProjectMember) staff;
   }


 }
