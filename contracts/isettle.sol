pragma solidity >=0.4.21 <0.7.0;

//SafeMath library
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

//SafeMath16 library
library SafeMath16 {
    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint16 a, uint16 b) internal pure returns (uint16 c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint16 a, uint16 b) internal pure returns (uint16 c) {
        require(b > 0);
        c = a / b;
    }
}

//iSettle contract
contract Isettle{

    using SafeMath for uint;
    using SafeMath16 for uint16;

    //state variables
    address owner;
    address[] adminsList;
    uint16[] lawyersList;
    string[] expertsList;
    string[] claimantsList;
    string[] respondantsList;
    uint caseCount = 0;
    uint16 adminIndex = 0;
    uint lawyerIndex = 0;
    uint expertIndex = 0;
    uint claimantIndex = 0;
    uint respondantIndex = 0;

    //Admin struct
    struct Admin{
        uint16 id;
        bool isAdmin;
    }

    //Lawyer struct
    struct Lawyer{
        string fullName;
        string speciality;
        uint16 supremeCourtNo;
        uint caseCount;
        uint lawyerIndex;
        bool isLawyer;
    }

    //Expert struct
    struct Expert{
        string fullName;
        string email;
        uint8 phoneNumber;
        string speciality;
        uint caseCount;
        uint expertIndex;
        bool isExpert;
    }

    //Complainant struct
    struct Claimant{
        string fullName;
        string email;
        uint8 phoneNumber;
        string complaints;
        uint claimantIndex;
        bytes32 caseHash;
    }

    //Respondant struct
    struct Respondant{
        string fullName;
        string email;
        uint8 phoneNumber;
        string response;
        uint respondantIndex;
        bytes32 caseHash;
    }
    
    //Case struct
    struct Case{
        uint caseIndex;     //number of cases
        bytes32 caseHash;   //used to locate a case
        Status status;      //to know the case status
        bool isSettled;     //to know if a case is settled or not
        string complaints;  //complainants agitation
        string response;    //defendants response
        string settlement;  //the lawyer(s) settlement
        string speciality;  //the case category
    }
    
    //Inmate struct
    struct Inmate{
        string fullName;        //name of inmate
        uint16 inmateNumber;    //inmate number
        string offense;         //offense committed
        uint8 timeSpent;        //number of days spent
        uint bailFee;           //bail fee
    }

    //Case status
    enum Status {
        Pending,
        Ongoing,
        Defaulted,
        Settled
    }

    Status public status;

    //Mappings
    mapping (address => Lawyer) lawyers;
    mapping (address => Expert) experts;
    mapping (bytes32 => Case) cases;
    mapping (uint => Claimant) claimants;
    mapping (uint => Respondant) respondants;
    mapping (address => Admin) admins;

    event AdminAdded(string msg, address newAdmin, uint indexed adminIndex);
    event AdminRemoved(address adminAddress, uint indexed adminIndex);
    event LawyerAdded(string msg, string fullName, string specialty, uint16 supremeCourtNo);
    event LawyerRemoved(address indexed lawyerAddress);
    event ExpertAdded(string msg, string fullName, string specialty);
    event ExpertRemoved(address indexed expertAddress);
    event ClaimantAdded(string msg, string complaints);
    event RespondantsAdded(string msg, string response);

    //Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, 'Access denied: Not owner');
        _;
    }

    modifier onlyAdmins() {
        require(admins[msg.sender].isAdmin == true, 'Access denied: Not an admin');
        _;
    }

    modifier onlyExpert(string memory _speciality) {
        Expert memory _expertStruct;
        require(
            experts[msg.sender].isExpert = true
        &&
            keccak256(
                abi.encodePacked(_expertStruct.speciality)
            ) ==
                keccak256(abi.encodePacked(_speciality)),
            'Not speciality'
        );
        _;
    }

    modifier onlyLawyer(string memory _speciality) {
        Lawyer memory _lawyerStruct;
        require(
            lawyers[msg.sender].isLawyer = true
        &&
            keccak256(
                abi.encodePacked(_lawyerStruct.speciality)
            ) ==
            keccak256(abi.encodePacked(_speciality)),
            'Not speciality'
        );
        _;
    }

    //Constructor function
    constructor() public {
        owner = msg.sender;
        //status = Status.pending;
        addAdmin(owner);
    }

    //Add admin function
    function addAdmin(address _newAdmin) public onlyOwner {
        Admin memory _adminStruct;
        require(admins[_newAdmin].isAdmin == false, 'Admin alreadty exists');
        admins[_newAdmin] = _adminStruct;
        _adminStruct.isAdmin = true;
        adminIndex = adminIndex.add(1);
        adminsList.push(_newAdmin);
        emit AdminAdded('New expert added:', _newAdmin, adminIndex);
    }

    //Remove admin function
    function removeAdmin(address _adminAddress) public onlyOwner {
        Admin memory _adminStruct;
        require(adminIndex > 1, 'Cannot operate without an admin');
        require(_adminStruct.isAdmin == true, 'Not an admin');
        require(_adminAddress != owner, 'Cannot remove owner');
        delete admins[_adminAddress];
        adminIndex = adminIndex.sub(1);
        emit AdminRemoved(_adminAddress, adminIndex);
    }

    //Add lawyer function
    function addLawyer(
        string memory _fullName,
        string memory _speciality,
        uint16 _supremeCourtNo
        ) public onlyAdmins
        {
        Lawyer memory _lawyerStruct;
        require(_lawyerStruct.isLawyer = false, 'Lawyer already exists');
        _lawyerStruct.fullName = _fullName;
        _lawyerStruct.speciality = _speciality;
        _lawyerStruct.supremeCourtNo = _supremeCourtNo;
        _lawyerStruct.caseCount = 0;
        _lawyerStruct.lawyerIndex = lawyerIndex.add(1);
        _lawyerStruct.isLawyer = true;
        lawyersList.push(_supremeCourtNo);
        emit LawyerAdded("New lawyer added:", _fullName, _speciality, _supremeCourtNo);
    }

    //Remove lawyer function
    function removeLawyer(address _lawyerAddress) public onlyAdmins {
        Lawyer memory _lawyerStruct;
        require(_lawyerStruct.isLawyer == true, 'Not a Lawyer');
        require(_lawyerAddress != owner, 'Cannot remove owner');
        delete lawyers[_lawyerAddress];
        _lawyerStruct.lawyerIndex = lawyerIndex.sub(1);
        emit LawyerRemoved(_lawyerAddress);
    }

    //Add expert function
    function addExpert(
        string memory _fullName,
        string memory _email,
        uint8 _phoneNumber,
        string memory _speciality
        ) public onlyAdmins
        {
        Expert memory _expertStruct;
        require(_expertStruct.isExpert = false,'Expert already exist');
        _expertStruct.fullName =_fullName;
        _expertStruct.email =_email;
        _expertStruct.phoneNumber =_phoneNumber;
        _expertStruct.speciality =_speciality;
        _expertStruct.caseCount = 0;
        _expertStruct.expertIndex = expertIndex.add(1);
        _expertStruct.isExpert = true;
		expertsList.push(_fullName);
        emit ExpertAdded('New expert added:', _fullName, _speciality);
    }

    //Remove expert function
    function removeExpert(address _expertAddress) public onlyAdmins {
        Expert memory _expertStruct;
        require(_expertStruct.isExpert == true, 'Not an Expert');
        require(_expertAddress != owner, 'Cannot remove owner');
        delete experts[_expertAddress];
        _expertStruct.expertIndex = expertIndex.sub(1);
        emit ExpertRemoved(_expertAddress);
    }

    //Add claimant function
    function addClaimant(
        string memory _fullName,
        string memory _email,
        uint8 _phoneNumber,
        string memory _complaints
        ) public
        {
        Claimant memory _claimantStruct;
        _claimantStruct.complaints = _complaints;
        _claimantStruct.email = _email;
        _claimantStruct.phoneNumber = _phoneNumber;
        _claimantStruct.claimantIndex = claimantIndex.add(1);
	    claimantsList.push(_fullName);
        emit ClaimantAdded("New complaint added:", _complaints);
    }

    //Add respondant function
    function addRespondant(
        string memory _fullName,
        string memory _email,
        uint8 _phoneNumber,
        string memory _response
        ) public
        {
        Respondant memory _respondantStruct;
        _respondantStruct.fullName = _fullName;
        _respondantStruct.email = _email;
        _respondantStruct.phoneNumber = _phoneNumber;
        _respondantStruct.response = _response;
        _respondantStruct.respondantIndex = respondantIndex.add(1);
		respondantsList.push(_fullName);
        emit RespondantsAdded("New response added:", _response);
        }
}