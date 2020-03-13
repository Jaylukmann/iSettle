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
        address lawyerId;
        string fullName;
        string email;
        uint phoneNumber;
        string speciality;
        uint supremeCourtNo;
        bool isLawyer; 
        address caseId;
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
        bool caseExist;//To know if a case already exist or no
	}
	
    struct Claimant{
        address claimantId;
        string fullName;
        string email;
        uint phoneNumber;
        string expertise;
        address caseId;
	}
	
    struct Respondant{
        address respondantId;
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
} 