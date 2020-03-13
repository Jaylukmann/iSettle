
pragma solidity >=0.4.21 <0.7.0;

contract Isettle{
    
    //state variables
    address internal owner;
    address[] public adminList;
    address[] public lawyerList; 
    address[] public expertList;
    string[] public claimantList;
    string[] public respondantList;
    address[] public caseList;
    address[] public inmateList;
    uint16 public adminIndex;
    uint public caseCount;
    uint public claimantIndex;
    uint public lawyerIndex;
    uint public expertIndex;
    uint public respondantIndex;
    uint public inmateIndex;

    struct Admin{
      uint adminId;
      bool isAdmin;
	}
	
    struct Lawyer{
        address lawyer;
        string fullName;
        string email;
        uint phoneNumber;
        string speciality;
        uint supremeCourtNo;
        bool isLawyer; 
        address caseId
	}
    
    struct Expert{
        address expertId;
        string fullName;
        string email;
        uint phoneNumber;
        string speciality;
        bool isExpert; 
        address caseId;
	}

    struct Case{
        address caseId;
        string complaints;//complainants agitation
        string response; //defendants response
        string settlement;//The lawyers(s) settlement 
        string caseSpeciality;
        bool isSettled;//To know if a case is settled or not
        bool caseExist;//To know if a case already exist or not
	}
	
    struct Claimant{
        address claimantId;
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
	
    struct Inmate{
        address inmateId;    
        string fullName;
        uint inmateNumber;
        uint bailFee;
    }

    enum caseStatus {Pending, Ongoing, Defaulted, Settled}
	caseStatus public casestatus;

    mapping (address => Lawyer) public lawyersmap;
    mapping (address => Expert) public expertsmap;
    mapping (address => Case) public casesmap;
    mapping (address => Claimant) public claimantsmap;
    mapping (address => Respondant) public respondantsmap;
    mapping (address => Admin) public adminsmap;
    mapping (address => Inmate) public inmatesmap;

    //MODIFIERS
    modifier onlyOwner(){
		require(msg.sender == owner, "Access denied, not owner");
		_; 
	}

    modifier onlyAdminsAndOwner{
	    require(adminsmap[msg.sender].isAdmin == true, "Access denied, only admin");
	    _;
	}

    modifier onlyExperts(){
	    require(expertsmap[msg.sender].isExpert == true, "Access denied, only expert");
	    _;
	}
	
	modifier onlyLawyers(){
	    require(lawyersmap[msg.sender].isLawyer == true, "Access denied, only lawyer");
	    _;
	}
	
      struct Inmates{
        address inmateId;    
        string fullName;
        string  homeAddress;
        bytes32 inmateNumber;
        uint  bailFee;
        bool exist;
        bool isFreed;
        }

        enum caseStatus {pending,ongoing,defaulted,settled}
	    caseStatus public casestatus;

        mapping (address =>Lawyers)public lawyersmap;
        mapping(address =>Experts)public expertsmap;
        mapping(address =>Case) public casesmap;
        mapping(address =>Complainants) public complainantsmap;
        mapping(address =>Respondents) public respondentsmap;
        mapping(address => Admin) public adminsmap;
        mapping(address => uint256) balances;

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
	
    //EVENTS
    event AdminAdded(address newAdmin, uint indexed adminIndex);
    event lawyersAdded(string msg, string indexed fullName, string speciality, uint _supremeCourtNo);
    event expertsAdded(string msg, string indexed fullName, string speciality);
    event AdminRemoved(address admin, uint indexed adminIndex);
    event LawyerRemoved(address lawyerAddress, uint indexed lawyersIndex);
    event ExpertRemoved(address expertAddress, uint indexed lawyersIndex);
    event CaseAdded(string msg,address _caseId ,string _caseSpeciality, string indexed _complaints);
    event ResponseAdded(string msg, address _caseId, string _caseSpeciality, string indexed _response);
    event ClaimantAdded(string msg, string indexed _fullName, address _claimantId);
    event RespondantAdded(string msg, string indexed _fullName, address _respondantId);
    event InmateAdded(string msg, string indexed _fullName, address _inmateId, uint indexed _inmateNumber, uint indexed _bailFee);
    event EthDonated(address indexed _addr, uint indexed _value);
     
    //CONSTRUCTOR
	constructor() public{
	    owner = msg.sender;
        addAdmin(owner);
		casestatus = caseStatus.Pending;
	}
	
    //FUNCTIONS
     
    //Allows owner to add an admin
	function addAdmin(address _newAdmin) public onlyOwner{
	    Admin memory _admin;
		require(adminsmap[_newAdmin].isAdmin == false,"Admin already exist");
		adminsmap[_newAdmin] = _admin;
		adminsmap[_newAdmin].isAdmin = true;
		adminIndex += 1;
		adminList.push(_newAdmin);
	    emit AdminAdded(_newAdmin, adminIndex);
    }
        
    //Allow the current owner to remove an Admin
	function removeAdmin(address _adminAddress) public onlyOwner{ 
		require(adminsmap[_adminAddress].isAdmin == true,"Sorry,address is not an admin");
		require(adminIndex > 1,"Atleast one admin is required");
		require(_adminAddress != owner,"owner cannot be removed");
		delete adminsmap[_adminAddress];
	    adminIndex -= 1;
		emit AdminRemoved(_adminAddress, adminIndex);
	}
       
    //Allows admins to add lawyers
    function addLawyer(
        address _lawyerId, 
        string memory _fullName, 
        string memory _email, 
        uint _phoneNumber, 
        string memory _speciality, 
        uint _supremeCourtNo
        ) public onlyAdminsAndOwner {
        Expert memory _expertStruct;
        Lawyer memory _lawyerStruct;
        require(_expertStruct.isExpert == false, "Already registered as an expert");
        require(_lawyerStruct.isLawyer == false, "Already registered as a lawyer");
        require(adminsmap[_lawyerId].isAdmin == false, "Address already exist as an admin");
        _lawyerStruct.lawyerId = _lawyerId;
        _lawyerStruct.email =_email;
        _lawyerStruct.phoneNumber = _phoneNumber;
        _lawyerStruct.fullName =_fullName;
        _lawyerStruct.speciality =_speciality;
        _lawyerStruct.supremeCourtNo =_supremeCourtNo;
        lawyersmap[_lawyerId] = _lawyerStruct;
        caseCount = 0;
        lawyerIndex += 1;
		lawyerList.push(_lawyerId);
        emit lawyersAdded("New lawyer added:", _fullName, _speciality, _supremeCourtNo);
    } 
    
    //Allow the current owner/admins to remove a Lawyer 
    function removeLawyer(address _lawyerAddress) public onlyAdminsAndOwner{ 
		require(lawyersmap[_lawyerAddress].isLawyer == true,"Sorry,address is not a lawyer");
		require(lawyerIndex > 1,"Atleast one lawyer is required");
		require(_lawyerAddress != owner,"owner cannot be removed");
		delete lawyersmap[_lawyerAddress];
		lawyerIndex -= 1;
		emit LawyerRemoved(_lawyerAddress, lawyerIndex);
	}

    //Allows admin to add experts
    function addExpert(
        address _expertId, 
        string memory _fullName, 
        string memory _email, 
        uint _phoneNumber, 
        string memory _speciality
        ) public onlyAdminsAndOwner {
        Lawyer memory _lawyerStruct;
        Expert memory _expertStruct;
        require(adminsmap[_expertId].isAdmin == false, "Address already exist as an admin");
        require(_expertStruct.isExpert == false, "Expert already exist");
        require(_lawyerStruct.isLawyer == false, "Already registered as a lawyer");
        _expertStruct.expertId = _expertId;
        _expertStruct.fullName = _fullName;
        _expertStruct.phoneNumber = _phoneNumber;
        _expertStruct.email = _email;
        _expertStruct.speciality = _speciality;
        expertsmap[_expertId] = _expertStruct; 
        caseCount = 0;
        expertIndex += 1;
        expertList.push(_expertId);
        emit expertsAdded("New expert added:", _fullName, _speciality);        
    } 
	
	//Allow the current owner/admins to remove an Expert
	function removeExpert(address _expertAddress) public onlyAdminsAndOwner{ 
		require(expertsmap[_expertAddress].isExpert == true,"Sorry,address is not an expert");
	    require(expertIndex > 1,"Atleast one expert is required");
		require(_expertAddress != owner,"owner cannot be removed");
		delete expertsmap[_expertAddress];
		expertIndex -= 1;
		emit ExpertRemoved(_expertAddress, expertIndex);
	}
    
    //Allow claimant to be added
    function addClaimant(
        address _claimantId, 
        string memory _fullName, 
        string memory _email, 
        uint _phoneNumber
        ) public onlyAdminsAndOwner {
        require(adminsmap[_claimantId].isAdmin == false,"Address already exist as an admin");
        Claimant memory claimantStruct;
        claimantStruct.claimantId = _claimantId;
        claimantStruct.fullName = _fullName;
        claimantStruct.email = _email;
        claimantStruct.phoneNumber = _phoneNumber;
        claimantsmap[_claimantId] = claimantStruct;
        claimantIndex += 1;
		claimantList.push(_fullName);
        emit ClaimantAdded("New claimant added:", _fullName, _claimantId);
    }

    //Allow respondant to be added
    function addRespondant(
        address _respondantId, 
        string memory _fullName, 
        uint _phoneNumber, 
        string memory _email
        ) public onlyAdminsAndOwner {
        Respondant memory respondantStruct;
        respondantStruct.respondantId = _respondantId;
        respondantStruct.fullName = _fullName;
        respondantStruct.email = _email;
        respondantStruct.phoneNumber = _phoneNumber;
        respondantsmap[_respondantId] = respondantStruct;
        respondantIndex += 1;
		respondantList.push(_email);
        emit RespondantAdded("New respondant added:", _fullName, _respondantId);
    } 
	   
	function lodgeComplaint(
	    address _caseId,
	    string memory _caseSpeciality,
	    string memory _complaint
	    ) public {
        Case memory _caseStruct;
        require(_caseStruct.caseExist == false, "Case already exist");
        require(_caseStruct.isSettled == false, "Case has been settled by a lawyer");
        require(casesmap[_caseId].caseExist == false, "Case already exist");
        _caseStruct.caseId = _caseId;
        _caseStruct.caseSpeciality = _caseSpeciality;
        casesmap[_caseId] = _caseStruct;
        caseCount += 1;
		caseList.push(_caseId);
        emit CaseAdded("New case added:", _caseId, _caseSpeciality, _complaint);
    }

	function respondToComplaint(
	    address _caseId, 
	    string memory _caseSpeciality, 
	    string memory _response
	    ) public{
        Case memory _caseStruct;
        require(_caseStruct.caseExist == true, "Case does not exist");
        require(_caseStruct.isSettled == false, "Case has been settled by a lawyer");
        _caseStruct.caseId = _caseId;
        _caseStruct.caseSpeciality = _caseSpeciality;
        casesmap[_caseId] = _caseStruct;
        caseCount += 1;
		caseList.push(_caseId);
        emit ResponseAdded("New response added:", _caseId, _caseSpeciality, _response);
    }

	function analyseCase(
	    address _caseId, 
	    string memory _caseSpeciality, 
	    string memory _complaint
	    ) public onlyExperts{
        Case memory _caseStruct;
        require(_caseStruct.caseExist == false,"Case already exist");
        require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
        require(casesmap[_caseId].caseExist == false,"Case already exist");
        _caseStruct.caseId = _caseId;
        _caseStruct.caseSpeciality =_caseSpeciality;
        caseCount += 1;
		caseList.push(_caseId);
        emit CaseAdded("New case added:", _caseId, _caseSpeciality, _complaint);
    }

	function resolveDispute(
	    address _caseId, 
	    string memory _caseSpeciality, 
	    string memory _complaint
	    ) public onlyLawyers{
        Case memory _caseStruct;
        require(_caseStruct.caseExist == false,"Case already exist");
        require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
        require(casesmap[_caseId].caseExist == false,"Case already exist");
        _caseStruct.caseId = _caseId;
        _caseStruct.caseSpeciality =_caseSpeciality;
        casesmap[_caseId] = _caseStruct;
        caseCount += 1;
		caseList.push(_caseId);
        emit CaseAdded("New case added:", _caseId, _caseSpeciality, _complaint);
    }
    
    function addInmate(
	    address _inmateId, 
	    string memory _fullName, 
	    uint _inmateNumber,
	    uint _bailFee
	    ) public onlyAdminsAndOwner{
        Inmate memory inmateStruct;
        inmateStruct.inmateId = _inmateId;
        inmateStruct.fullName = _fullName;
        inmateStruct.inmateNumber = _inmateNumber;
        inmateStruct.bailFee = _bailFee;
        inmatesmap[_inmateId] = inmateStruct;
        inmateIndex += 1;
        inmateList.push(_inmateId);
        emit InmateAdded("New inmate added:", _fullName, _inmateId, _inmateNumber, _bailFee);
    }
    
    function donateEth(address payable _inmateId, uint _amount) external payable {
        Inmate memory inmateStruct;
        require(inmateStruct.bailFee > _amount, 'Cannot donate more than bailFee');
        inmateStruct.inmateId = _inmateId;
        inmateStruct.bailFee -= _amount;
        inmatesmap[_inmateId] = inmateStruct;
        emit EthDonated(_inmateId, _amount);
    }
                         //EVENTS
        event AdminAdded(address newAdmin,uint indexed adminIndex);
        event lawyersAdded(string msg,string indexed fullName,string speciality,uint _supremeCourtNo);
        event expertsAdded(string msg,string indexed fullName,string speciality);
    
        event AdminRemoved(address admin,uint indexed adminIndex);
        event LawyerRemoved(address lawyerAddress,uint indexed lawyersIndex);
        event ExpertRemoved(address expertAddress,uint indexed lawyersIndex);
     
        event CaseAdded(string msg,address  indexed caseId,string caseSpeciality,string  complaints);
        event ResponseAdded(string msg,address indexed  caseId,string caseSpeciality,string  _response);
        event CaseAnalysisAdded(string msg,address indexed  caseId,string caseSpeciality,string );
        event CaseResolutionAdded(string msg,address indexed  caseId,string caseSpeciality,string response);
        event NewInmateAdded(string msg,address _inmateId, string _fullName,string _homeAddress,bytes32 _inmateNumber,uint _bailFee);
     
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
        function addLawyer(address _lawyersId,string memory _fullName,string memory _email,uint _phoneNumber,string memory _speciality,uint _supremeCourtNo)public onlyAdmins {
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
        function addExpert(address _expertsId,string memory _fullName,string memory _email,uint _phoneNumber,string memory _speciality)public onlyAdmins {
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
        function addComplainant(address _complainantsId,string memory _fullName,string memory _email,uint _phoneNumber)public onlyAdmins {
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

        function addRespondents(address _respondentsId,string memory _fullName,uint _phoneNumber, string memory _email)public onlyAdmins {
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
	   
	    function lodgeComplaint(address _caseId,string memory _caseSpeciality,string memory _complaint)public {
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


	    function analyseCase(address _caseId,string memory _caseSpeciality,string memory _analysis)public onlyExperts {
            Case memory _caseStruct;
            require(_caseStruct.caseExist == false,"Case already exist");
            require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
            require(casesmap[_caseId].caseExist == false,"Case already exist");
            _caseStruct.caseId = _caseId;
            _caseStruct.caseSpeciality =_caseSpeciality;
            caseCount += 1;
		    caseList.push(_caseId);
            emit CaseAnalysisAdded("New case analysis added:",_caseId,_caseSpeciality,_analysis);
        }


	    function resolveDispute(address _caseId,string memory _caseSpeciality,string memory _resolution)public onlyLawyers {
            Case memory _caseStruct;
            require(_caseStruct.caseExist == false,"Case already exist");
            require(_caseStruct.isSettled == false,"Case has been settled by a lawyer");
            require(casesmap[_caseId].caseExist == false,"Case already exist");
            _caseStruct.caseId = _caseId;
            _caseStruct.caseSpeciality =_caseSpeciality;
            caseCount += 1;
		    caseList.push(_caseId);
            emit CaseResolutionAdded("New case resolution added:",_caseId,_caseSpeciality,_resolution);
        }

        function addInmate(address _inmateId,string memory _fullName,string memory _homeAddress,bytes32 _inmateNumber,uint _bailFee)public {
            Inmates memory inmateStruct;
            require(inmateStruct.exist == false,"inmate already exist");
            inmateStruct.inmateId = _inmateId;
            inmateStruct.fullName =_fullName;
            inmateStruct.homeAddress =_homeAddress;
            inmateStruct.inmateNumber =_inmateNumber;
            inmateStruct.bailFee =_bailFee;
            inmateCount += 1;
		    inmateList.push(_inmateId);
            emit NewInmateAdded("New inmate added:",_inmateId,_fullName,_homeAddress,_inmateNumber,_bailFee);      
        }
        
        function freeInmate(address inmateId,string memory fullName,bytes32 inmateNumber,uint  bailFee)public {
            Inmates memory inmateStruct;
            require(inmateStruct.exist == true,"inmate does not exist");
            require(inmateStruct.isFreed == false,"inmate");
        }

        function  donateEth(uint _donation) public payable {
            balances[msg.sender] -=  _donation;
            donationTotal +=  _donation; 
            donationCount += 1;
            require(_donation >= 5000000000000000,"Below minimum donation");
        }

        function withdraw(uint _withdrawal)  public payable onlyOwner{
        balances[msg.sender] +=  _withdrawal;
        donationTotal -=  _withdrawal; 
        require(msg.sender.send(donationTotal));
    
       }

	} 

