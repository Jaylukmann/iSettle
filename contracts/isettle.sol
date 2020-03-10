 pragma solidity >=0.4.21 <0.7.0;
contract Isettle{
    //state variables
    address owner;
    address[] public adminsList;
    uint[] public lawyersList; 
    address[] public  expertsList;
    string[] public claimantsList;
    string[] public respondentsList;
    address[] public caseList;
    uint16 public adminIndex;
    uint public caseCount;
    uint public claimantsIndex;
    uint public  lawyersIndex;
    uint public expertsIndex;
    uint public respondentsIndex;

     struct Admin{
      address adminId;
      bool isAdmin;
	}
     struct Lawyers{
         address lawyersId;
        string fullName;
        string email;
        uint phoneNumber;
        string speciality;
        uint supremeCourtNo;
        bool isLawyer; 
        address caseId;
	}
     struct  Experts{
         address expertsId;
        string fullName;
        string email;
        uint phoneNumber;
        string speciality;
        bool isExpert; 
        address caseId;
	}

    struct Case{
	//number of cases
        address caseId;
        string complaints;//complainants agitation
        string response; //defendants response
        string settlement;//The lawyers(s) settlement 
        string caseSpeciality;
        bool isSettled;//To know if a case is settled or not
        bool caseExist;//To know if a case already exist or no
	}
	
     struct Complainants{
        address complainantsId;
        string fullName;
        string email;
        uint phoneNumber;
        string expertise;
        address caseId;
	}
        struct Respondents{
        address respondentsId;
        string fullName;
        uint phoneNumber;
        string email;
        string expertise;
        address caseId;
	}
    struct Inmates{
    address inmatesId;    
     string fullname;
     uint inmateNumber;
     uint  bailFee;
    }

     enum caseStatus {pending,ongoing,defaulted,settled}
	 caseStatus public casestatus;

    mapping (address =>Lawyers)public lawyersmap;
    mapping(address =>Experts)public expertsmap;
    mapping(address =>Case) public casesmap;
    mapping(address =>Complainants) public complainantsmap;
    mapping(address =>Respondents) public respondentsmap;
    mapping(address => Admin) public adminsmap;

    //MODIFIERS
    modifier onlyOwner(){
		require(msg.sender == owner, "Access denied,not the owner");
		_; 
	}

    modifier onlyAdmins{
	    require(adminsmap[msg.sender].isAdmin,"Access denied,only admin");
	    _;
	}

 modifier onlyExperts(){
	    require(expertsmap[msg.sender].isExpert,"Access denied,only expert");
	    _;
	}
	
	modifier onlyLawyers(){
	    require(lawyersmap[msg.sender].isLawyer,"Access denied,only lawyer");
	    _;
	}
    //modifier onlyExperts(string memory _speciality){
        //Experts memory expertStruct;
	    //require(expertsmap[msg.sender].isExpert == true && 
        // keccak256(abi.encodePacked(expertStruct.speciality))
         //== keccak256(abi.encodePacked(_speciality)),"Not an expert or in the field");
	   // _;
	//}
     //modifier onlyLawyers(string memory _speciality){
       // Lawyers memory lawyerStruct;
	    //require(lawyersmap[msg.sender].isLawyer == true && 
         //keccak256(abi.encodePacked(lawyerStruct.speciality))
         //== keccak256(abi.encodePacked(_speciality)),"Not an expert or in the field");
	    //_;
	//}
    //EVENTS
    event AdminAdded(address newAdmin,uint indexed adminIndex);
    event lawyersAdded(string msg,string indexed fullName,string speciality,uint _supremeCourtNo);
    event expertsAdded(string msg,string indexed fullName,string speciality);
    
     event AdminRemoved(address admin,uint indexed adminIndex);
     event LawyerRemoved(address lawyerAddress,uint indexed lawyersIndex);
     event ExpertRemoved(address expertAddress,uint indexed lawyersIndex);
     
     event CaseAdded(string msg,address _caseId,string _caseSpeciality,string indexed _complaints);
      event ResponseAdded(string msg,address _caseId,string _caseSpeciality,string indexed _response);
     
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
		 adminsmap[_newAdmin].isAdmin = true;
		 adminIndex += 1;
		 adminsList.push(_newAdmin);
		emit AdminAdded(_newAdmin,adminIndex);
       } 
       
       //Allows admins to add lawyers
         function addLawyer(address _lawyersId,
                            string memory _fullName,
                            string memory _email,
                            uint _phoneNumber,
                            string memory _speciality,
                            uint _supremeCourtNo)
           public onlyAdmins {
               Experts memory _expertStruct;
               Lawyers memory _lawyerStruct;
               require(_expertStruct.isExpert == false,"Already registered as an expert");
               require(_lawyerStruct.isLawyer == false,"Already registered as a lawyer");
               require(adminsmap[_lawyersId].isAdmin == false,"Address already exist as an admin");
               _lawyerStruct.lawyersId =_lawyersId;
                _lawyerStruct.email =_email;
                _lawyerStruct.phoneNumber = _phoneNumber;
               _lawyerStruct.fullName =_fullName;
               _lawyerStruct.speciality =_speciality;
               _lawyerStruct.supremeCourtNo =_supremeCourtNo;
               caseCount = 0;
               lawyersIndex += 1;
		       lawyersList.push(_supremeCourtNo);
       emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
}
             //Allows admin to add  experts
            function addExpert(address _expertsId,
                    string memory _fullName,
                    string memory _email,
                    uint _phoneNumber,
                    string memory _speciality
                    )
                    public onlyAdmins {
               Lawyers memory _lawyerStruct;
               Experts memory _expertStruct;
               require(adminsmap[_expertsId].isAdmin == false,"Address already exist as an admin");
                require(_expertStruct.isExpert == false,"Expert already exist");
                require(_lawyerStruct.isLawyer == false,"Already registered as a lawyer");
                _expertStruct.expertsId =  _expertsId;
               _expertStruct.fullName =_fullName;
               _expertStruct.phoneNumber =_phoneNumber;
               _expertStruct.email =_email;
               _expertStruct.speciality =_speciality;
               caseCount = 0;
               expertsIndex += 1;
               emit expertsAdded("New expert added:",_fullName,_speciality);        
}
 function addComplainant(address _complainantsId,
                         string memory _fullName,
                         string memory _email,
                         uint _phoneNumber)
           public onlyAdmins {
             //Case memory caseStruct;
             require(adminsmap[_complainantsId].isAdmin == false,"Address already exist as an admin");
            Complainants memory complainantStruct;
            complainantStruct.complainantsId =_complainantsId;
            complainantStruct.fullName =_fullName;
            complainantStruct.email =_email;
            complainantStruct.phoneNumber =_phoneNumber;
            claimantsIndex += 1;
		    claimantsList.push(_fullName);
      // emit lawyersAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
           }
            function addRespondents(address _respondentsId,
                                    string memory _fullName,
                                    uint _phoneNumber,
                                    string memory _email)
                         public onlyAdmins {
                         Respondents memory respondentStruct;
                         respondentStruct.respondentsId =_respondentsId;
                        respondentStruct.fullName =_fullName;
                        respondentStruct.email =_email;
                        respondentStruct.phoneNumber =_phoneNumber;
                        respondentsIndex += 1;
		                 respondentsList.push(_email);
                        //emit respondentsAdded("New lawyer added:",_fullName,_speciality,_supremeCourtNo);
        }
        
         //Allow the current owner to remove an Admin
	   function removeAdmin(address _adminAddress) public onlyOwner{ 
		   		 require(adminsmap[_adminAddress].isAdmin == true,"Sorry,address is not an admin");
				 require(adminIndex > 1,"Atleast one admin is required");
				 require(_adminAddress != owner,"owner cannot be removed");
				 delete adminsmap[_adminAddress];
				 adminIndex -= 1;
				 emit AdminRemoved( _adminAddress,adminIndex);
	   } 
        
         function removeLawyer(address _lawyerAddress) public onlyOwner{ 
		   		 require(lawyersmap[_lawyerAddress].isLawyer == true,"Sorry,address is not a lawyer");
				 require(lawyersIndex > 1,"Atleast one lawyer is required");
				 require(_lawyerAddress != owner,"owner cannot be removed");
				 delete lawyersmap[_lawyerAddress];
				 adminIndex -= 1;
				 emit LawyerRemoved( _lawyerAddress,lawyersIndex);
	   } 
	   
	    function removeExpert(address _expertAddress) public onlyOwner{ 
		   		 require(expertsmap[_expertAddress].isExpert == true,"Sorry,address is not an expert");
				 require(expertsIndex > 1,"Atleast one expert is required");
				 require(_expertAddress != owner,"owner cannot be removed");
				 delete expertsmap[_expertAddress];
				 adminIndex -= 1;
				 emit ExpertRemoved( _expertAddress,expertsIndex);
	   } 
	   
	    function lodgeComplaint(address _caseId,string memory _caseSpeciality,string memory _complaint)public 
	     {
               Case memory _caseStruct;
               require(_caseStruct.caseExist == false,"Case already exist");
               require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
               require(casesmap[_caseId].caseExist == false,"Case already exist");
               _caseStruct.caseId = _caseId;
               _caseStruct.caseSpeciality =_caseSpeciality;
               caseCount += 1;
		       caseList.push(_caseId);
       emit CaseAdded("New case added:",_caseId,_caseSpeciality,_complaint);
}

	    function respondToComplaint(address _caseId,string memory _caseSpeciality,string memory _response)public {
               Case memory _caseStruct;
               require(_caseStruct.caseExist == true,"Case does not exist");
               require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
               _caseStruct.caseId = _caseId;
               _caseStruct.caseSpeciality =_caseSpeciality;
               caseCount += 1;
		       caseList.push(_caseId);
               emit ResponseAdded("New response added:",_caseId,_caseSpeciality,_response);
        }


	    function analyseCase(address _caseId,string memory _caseSpeciality,string memory _complaint)public onlyExperts {
               Case memory _caseStruct;
               require(_caseStruct.caseExist == false,"Case already exist");
               require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
               require(casesmap[_caseId].caseExist == false,"Case already exist");
               _caseStruct.caseId = _caseId;
               _caseStruct.caseSpeciality =_caseSpeciality;
               caseCount += 1;
		       caseList.push(_caseId);
               emit CaseAdded("New case added:",_caseId,_caseSpeciality,_complaint);
        }


	    function resolveDispute(address _caseId,string memory _caseSpeciality,string memory _complaint)public onlyLawyers {
               Case memory _caseStruct;
               require(_caseStruct.caseExist == false,"Case already exist");
               require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
               require(casesmap[_caseId].caseExist == false,"Case already exist");
               _caseStruct.caseId = _caseId;
               _caseStruct.caseSpeciality =_caseSpeciality;
               caseCount += 1;
		       caseList.push(_caseId);
               emit CaseAdded("New case added:",_caseId,_caseSpeciality,_complaint);
        }

	} 