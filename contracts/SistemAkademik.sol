// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SistemAkademik {
    struct Mahasiswa {
        string nama;
        uint256 nim;
        string jurusan;
        uint256[] nilai;
        bool isActive;
    }
    
    mapping(uint256 => Mahasiswa) public mahasiswa;
    mapping(address => bool) public authorized;
    uint256[] public daftarNIM;
    
    event MahasiswaEnrolled(uint256 nim, string nama);
    event NilaiAdded(uint256 nim, uint256 nilai);
    
    modifier onlyAuthorized() {
        require(authorized[msg.sender], "Tidak memiliki akses");
        _;
    }
    
    constructor() {
        authorized[msg.sender] = true;
    }
    
    // TODO: Implementasikan enrollment function
    function enroll(string calldata nama, uint256 nim, string calldata jurusan) public onlyAuthorized {
        daftarNIM.push(nim);
        mahasiswa[nim] = Mahasiswa(nama, nim, jurusan, new uint256[](0), true);
        emit MahasiswaEnrolled(nim, nama);
    }

    // TODO: Implementasikan add grade function
    function addGrade(uint256 nim, uint256 grade) public onlyAuthorized {
        mahasiswa[nim].nilai.push(grade);
        emit NilaiAdded(nim, grade);
    }

    // TODO: Implementasikan get student info function
    function getStudentInfo(uint256 nim) public view returns (Mahasiswa memory) {
        return mahasiswa[nim];
    }
}