pragma solidity >=0.4.21 <0.7.0;
contract Isettle{
    //state variables
    address owner;
    address[] adminsList;
    uint[] lawyersList; 
    address[] expertsList;
    address[]  claimantsList;
    address[] respondentsList;

     struct Admin{
	  uint16 adminIndex;
      bool isAdmin;
	}
     struct Lawyers{
        string fullName;
        string speciality;
        uint supremeCourtNo;
        uint caseCount;
		uint lawyersIndex;
        uint caseHash;
        string settlement; //The lawyers(s) settlement 
        bool isLawyer;  
	}
     struct  Experts{
        uint caseCount;
		uint expertsIndex;
        bytes32 caseHash;
        string speciality;
        string analysis;//The lawyers(s) settlement  
        bool isExpert; 
	}

    struct Case{
		uint caseIndex;//number of cases
        bytes32 caseHash; //use to locate a case
        bool isSettled; //To know if a case is settled or not
        string complaints;//complainants agitation
        string response; //defendants response
        string settlement;//The lawyers(s) settlement 
        string speciality;
        
	}
     struct Complainants{
        bytes32 caseHash;
        bool isSettled;
        string settlement; 
        string complaints;
        uint claimantsIndex; 
	}
        struct Respondents{
        uint caseHash;
        bool isSettled;
        string settlement; 
        uint16 respondentsIndex;
        string response; 
	}
    struct Inmates{
     string fullname;
     uint16 inmateNumber;
     uint  bailFee;
    }

     enum caseStatus {pending,ongoing,defaulted,settled}
	 caseStatus public casestatus;

    mapping(address =>Lawyers)lawyersmap;
    mapping(address =>Experts)expertsmap;
    mapping(bytes32 =>Case)casesmap;
    mapping(uint =>Complainants)complainantsmap;
    mapping(uint =>Respondents)respondentsmap;
    mapping(address => Admin)adminsmap;

    //MODIFIERS
    modifier onlyOwner(){
		require(msg.sender == owner, "Access denied,not the owner");
		_; 
	}

    modifier onlyAdmins(){
	    require(adminsmap[msg.sender].isAdmin == true,"Access denied,only admin");
	    _;
	}

    modifier onlyExpert(string memory _speciality){
        Experts memory expertStruct;
	    require(expertsmap[msg.sender].isExpert == true && 
         keccak256(abi.encodePacked(expertStruct.speciality))
         == keccak256(abi.encodePacked(_speciality)),"Not an expert or in the field");
	    _;
	}
     modifier onlyLawyers(string memory _speciality){
        Lawyers memory lawyerStruct;
	    require(lawyersmap[msg.sender].isLawyer == true && 
         keccak256(abi.encodePacked(lawyerStruct.speciality))
         == keccak256(abi.encodePacked(_speciality)),"Not an expert or in the field");
	    _;
	}
    //EVENTS
    event AdminAdded(address newAdmin,uint indexed adminIndex);
    event AdminRemoved(address admin,uint indexed adminIndex);
    event lawyersAdded(string msg,string indexed fullName,string speciality,uint16 _supremeCourtNo);
    //CONSTRUCTOR
	constructor() public{
		owner = msg.sender;
        addAdmin(owner);
		casestatus = caseStatus.pending;
	}
     //FUNCTIONS
      //Allows owner to add an admin
	 function addAdmin(address _newAdmin) public onlyOwner{
	     Admin memory _admin;
		 require(adminsmap[_newAdmin].isAdmin == false,"Admin already exist");
	     adminsmap[_newAdmin] = _admin;
		_admin.adminIndex += 1;
		adminsList.push(_newAdmin);
		emit AdminAdded(_newAdmin,_admin.adminIndex);
       } 
        //Allow the current owner to remove an Admin
	   function removeAdmin(address _adminAddress) public onlyOwner{ 
		     	 Admin memory _admin;
		   		 require(_admin.isAdmin == true,"Admin is not  authorised");
				 require(_admin.adminIndex > 1,"Atleast one admin is required");
				 require(_adminAddress != owner,"owner cannot be removed");
				 delete adminsmap[_adminAddress];
				 _admin.adminIndex -= 1;
				 emit AdminRemoved( _adminAddress,_admin.adminIndex);
	   } 
         function addLawyer(string memory _fullName,
            string memory _speciality,
            uint16 _supremeCourtNo)
           public onlyAdmins{
               Lawyers memory _lawyerStruct;
                require(_lawyerStruct.isLawyer = false,"Lawyer already exist");
               _lawyerStruct.fullName =_fullName;
               _lawyerStruct.speciality =_speciality;
               _lawyerStruct.supremeCourtNo =_supremeCourtNo;
               _lawyerStruct.caseCount = 0;
               _lawyerStruct.lawyersIndex += lawyersList.length;
		       lawyersList.push(_supremeCourtNo);
       emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
}
 function addExpert(string memory _fullName,
            string memory _speciality,
            uint16 _supremeCourtNo)
           public onlyAdmins{
               Lawyers memory _lawyerStruct;
                require(_lawyerStruct.isLawyer = false,"Lawyer already exist");
               _lawyerStruct.fullName =_fullName;
               _lawyerStruct.speciality =_speciality;
               _lawyerStruct.supremeCourtNo =_supremeCourtNo;
               _lawyerStruct.caseCount = 0;
               _lawyerStruct.lawyersIndex += lawyersList.length;
		       lawyersList.push(_supremeCourtNo);
       emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);        
}
 function addComplainant(string memory _fullName,
            string memory _speciality,
            uint16 _supremeCourtNo)
           public onlyAdmins{
               Lawyers memory _lawyerStruct;
                require(_lawyerStruct.isLawyer = false,"Lawyer already exist");
               _lawyerStruct.fullName =_fullName;
               _lawyerStruct.speciality =_speciality;
               _lawyerStruct.supremeCourtNo =_supremeCourtNo;
               _lawyerStruct.caseCount = 0;
               _lawyerStruct.lawyersIndex += lawyersList.length;
		       lawyersList.push(_supremeCourtNo);
       emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
           }
            function addRespondents(string memory _fullName,
            string memory _speciality,
            uint16 _supremeCourtNo)
           public onlyAdmins{
               Lawyers memory _lawyerStruct;
                require(_lawyerStruct.isLawyer = false,"Lawyer already exist");
               _lawyerStruct.fullName =_fullName;
               _lawyerStruct.speciality =_speciality;
               _lawyerStruct.supremeCourtNo =_supremeCourtNo;
               _lawyerStruct.caseCount = 0;
               _lawyerStruct.lawyersIndex += lawyersList.length;
		       lawyersList.push(_supremeCourtNo);
       emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
        }
} 