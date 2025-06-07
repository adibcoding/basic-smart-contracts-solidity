// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract PemilihanBEM {
    struct Kandidat {
        string nama;
        string visi;
        uint256 suara;
    }
    
    Kandidat[] public kandidat;
    mapping(address => bool) public sudahMemilih;
    mapping(address => bool) public pemilihTerdaftar;
    
    uint256 public waktuMulai = 0;
    uint256 public waktuSelesai = type(uint256).max;
    address public admin = msg.sender;
    
    event VoteCasted(address indexed voter, uint256 kandidatIndex);
    event KandidatAdded(string nama);
    
    modifier onlyDuringVoting() {
        require(
            block.timestamp >= waktuMulai && 
            block.timestamp <= waktuSelesai, 
            "Voting belum dimulai atau sudah selesai"
        );
        _;
    }
    
    // TODO: Implementasikan add candidate function
    function addCandidate(string calldata name, string calldata visi) adminOnly public {
        kandidat.push(Kandidat(name, visi, 0));
        emit KandidatAdded(name);
    }

    // TODO: Implementasikan vote function
    function vote(string calldata candidateName) public onlyDuringVoting registeredVoterOnly alreadyVoted {
        for (uint256 i = 0; i < kandidat.length; i++) {
            if (keccak256(abi.encodePacked(kandidat[i].nama)) == keccak256(abi.encodePacked(candidateName))) {
                kandidat[i].suara++;
                sudahMemilih[msg.sender] = true;
                emit VoteCasted(msg.sender, i);
            }
        }
    }

    modifier registeredVoterOnly() {
        require(pemilihTerdaftar[msg.sender] == true, "Only registered voter");
        _;
    }

    modifier alreadyVoted() {
        require(sudahMemilih[msg.sender] == false, "You have voted already");
        _;
    }

    modifier adminOnly() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }

    function registerVoters(address voter) public adminOnly {
        pemilihTerdaftar[voter] = true;
    }

    // TODO: Implementasikan get results function
    function getResults() public view returns(Kandidat[] memory) {
        return kandidat;
    }

    function getResultByCandidateIndex(uint256 candidateIndex) public view returns(Kandidat memory) {
        return kandidat[candidateIndex];
    }
}