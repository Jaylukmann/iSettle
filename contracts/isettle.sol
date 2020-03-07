pragma solidity >=0.4.21 <0.7.0;

contract Isettle{
    //state variables
    address owner;
    address[] adminsList;
    uint[] lawyersList; 
    uint[] expertsList;
    uint[] claimantsList;
    uint[] respondentsList;

    struct Admin{
        uint16 adminIndex;
        bool isAdmin;
    }
    
    struct Lawyers{
        string fullName;
        string speciality;
        uint16 supremeCourtNo;
        uint caseCount;
        uint lawyersIndex;
        uint caseHash;
        string settlement; //The lawyers(s) settlement   
        bool isLawyer;
    }
    
    struct  Experts{
        string fullName;
        string speciality;
        uint caseCount;
        uint expertsIndex;
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
        bool isSettled;
        string complaints;
        string speciality;
        uint claimantsIndex; 
    }
    
    struct Respondents{
        bool isSettled; 
        uint respondentsIndex;
        string response; 
    }
    
    struct Inmate {
        string fullName;
        uint16 inmateNumber;
        uint bailFee; 
    }
    
    enum caseStatus {
        pending,
        ongoing,
        defaulted,
        settled
    }
    
    caseStatus public casestatus;

    mapping (address => Lawyers) lawyersmap;
    mapping (address => Experts) expertsmap;
    mapping (bytes32 => Case) casesmap;
    mapping (uint => Complainants) complainantsmap;
    mapping (uint => Respondents) respondentsmap;
    mapping (address => Admin) adminsmap;
    
    event AdminAdded(address newAdmin, uint indexed adminIndex);
    event AdminRemoved(address adminAddress, uint indexed adminIndex);
    event LawyerAdded(string msg, string fullName, string specialty, uint16 supremeCourtNo);
    event LawyerRemoved(address lawyerAddress, uint indexed lawyersIndex);
    event ExpertAdded(string msg, string fullName, string specialty);
    event ExpertRemoved(address expertAddress, uint indexed expertsIndex);
    event ComplaintsAdded(string msg, string complaints, string speciality);
    event RespondentsAdded(string msg, string response);
     
    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner can call this function');
        _;
    }
    
    modifier onlyAdmin() {
        require(adminsmap[msg.sender].isAdmin == true, 'Only admins can call this function');
        _;
    }
    
    modifier onlyExpert(string memory _speciality) {
        Experts memory _expertStruct;
        require(expertsmap[msg.sender].isExpert = true && 
        keccak256(abi.encodePacked(_expertStruct.speciality)) == 
        keccak256(abi.encodePacked(_speciality)));
        _;
    }
    
    modifier onlyLawyer(string memory _speciality) {
        Lawyers memory _lawyerStruct;
        require(lawyersmap[msg.sender].isLawyer = true && 
        keccak256(abi.encodePacked(_lawyerStruct.speciality)) == 
        keccak256(abi.encodePacked(_speciality)));
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        casestatus = caseStatus.pending;
        addAdmin(owner);
    }

    function addAdmin(address _newAdmin) public onlyOwner {
        Admin memory _admin;
        require(adminsmap[_newAdmin].isAdmin == false, 'Admin alreadty exists');
        adminsmap[_newAdmin] = _admin;
        _admin.adminIndex += 1;
        adminsList.push(_newAdmin);
        emit AdminAdded(_newAdmin, _admin.adminIndex);
    }
    
    function removeAdmin(address _adminAddress) public onlyOwner {
        Admin memory _admin;
        require(_admin.adminIndex > 1, "Cannot operate without admin"); 
        require(_admin.isAdmin == true, 'Not an admin');
        require(_adminAddress != owner, 'Cannot remove owner');
        delete adminsmap[_adminAddress];
        _admin.adminIndex -= 1;
        emit AdminRemoved(_adminAddress, _admin.adminIndex);
    }

    function addLawyer(
        string memory _fullName,
        string memory _speciality,
        uint16 _supremeCourtNo
        ) public onlyAdmin 
    {
        
        Lawyers memory _lawyerStruct;
        require(_lawyerStruct.isLawyer = false, 'Lawyer already exists');
        _lawyerStruct.fullName = _fullName;
        _lawyerStruct.speciality = _speciality;
        _lawyerStruct.supremeCourtNo = _supremeCourtNo;
        _lawyerStruct.caseCount = 0;
        _lawyerStruct.lawyersIndex += lawyersList.length;
        _lawyerStruct.isLawyer = true;
        lawyersList.push(_supremeCourtNo);
        emit LawyerAdded("New lawyer added:", _fullName, _speciality, _supremeCourtNo);
    }
    
    function removeLawyer(address _lawyerAddress) public onlyAdmin {
        Lawyers memory _lawyers;
        require(_lawyers.isLawyer == true, 'Not a Lawyer');
        require(_lawyerAddress != owner, 'Cannot remove owner');
        delete lawyersmap[_lawyerAddress];
        _lawyers.lawyersIndex -= 1;
        emit LawyerRemoved(_lawyerAddress, _lawyers.lawyersIndex);
    }  
    
    function addExpert(
        string memory _fullName,
        string memory _speciality
        ) public onlyAdmin{
        
        Experts memory _expertStruct;
        require(_expertStruct.isExpert = false,"Expert already exist");
        _expertStruct.fullName =_fullName;
        _expertStruct.speciality =_speciality;
        _expertStruct.caseCount = 0;
        _expertStruct.expertsIndex += expertsList.length;
        _expertStruct.isExpert = true;
		expertsList.push(_expertStruct.expertsIndex);
        emit ExpertAdded("New expert added:", _fullName, _speciality);        
}
    
    function removeExpert(address _expertAddress) public onlyAdmin {
        Experts memory _experts;
        require(_experts.isExpert == true, 'Not an Expert');
        require(_expertAddress != owner, 'Cannot remove owner');
        delete expertsmap[_expertAddress];
        _experts.expertsIndex -= 1;
        emit ExpertRemoved(_expertAddress, _experts.expertsIndex);
    }  
    
    function addComplainant(string memory _complaints, string memory _speciality) public onlyAdmin{
        Complainants memory _complainantsStruct;
        require(_complainantsStruct.isSettled = false,"Complaint already settled");
        _complainantsStruct.complaints = _complaints;
        _complainantsStruct.speciality = _speciality;
        _complainantsStruct.isSettled = true;
        _complainantsStruct.claimantsIndex += claimantsList.length;
	    claimantsList.push(_complainantsStruct.claimantsIndex);
        emit ComplaintsAdded("New complaint added:", _complaints, _speciality);
    }

    function addRespondents(string memory _response) public onlyAdmin{
        Respondents memory _respondentStruct;
        require(_respondentStruct.isSettled = false,"Complaint already settled");
        _respondentStruct.response = _response;
        _respondentStruct.isSettled = true;
        _respondentStruct.respondentsIndex += respondentsList.length;
		respondentsList.push(_respondentStruct.respondentsIndex);
        emit RespondentsAdded("New response added:", _response);
        }
   
}