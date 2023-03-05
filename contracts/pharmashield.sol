//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PharmaShield is ERC20 {
    address owner;
    // Example Token Symbols - 
    // i. 0x666f6f0000000000000000000000000000000000000000000000000000000000
    // ii. 0x6261720000000000000000000000000000000000000000000000000000000000
    // iii. 0x666f6f0000000000000000000000000000000000000000000000000000000000
    // iv. 0x6261720000000000000000000000000000000000000000000000000000000000
    bytes32[] tokenSymbols;
    mapping(bytes32 => string) tokenSymbolsWithName;
    mapping(bytes32 => uint256) public tokenBalance;
    address[] manufacturersList;
    address[] logisticsList;
    address[] pharmaList;
    address[] doctorsList;
    address[] suppliersList;

    event tokenSent(address from, address to, bytes32 symbol);

    constructor() ERC20("PharmaShield", "PS") {
        owner = msg.sender;
    }

    function getTokenBalance(bytes32 symbol) public view returns (uint256){
        return tokenBalance[symbol];
    }
    function getTokenName(bytes32 symbol) public view returns (string memory){
        return tokenSymbolsWithName[symbol];
    }

    function getOwner() public view returns (address){
        return owner;
    }

    function verifyManufacturer() public view returns (bool){
        for (uint i=0; i<manufacturersList.length; i++){
            if (manufacturersList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifyDoctor() public view returns (bool){
        for (uint i=0; i<doctorsList.length; i++){
            if (doctorsList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifySuppliers() public view returns (bool){
        for (uint i=0; i<suppliersList.length; i++){
            if (suppliersList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifyPharma() public view returns (bool){
        for (uint i=0; i<pharmaList.length; i++){
            if (pharmaList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifyLogistics() public view returns (bool){
        for (uint i=0; i<logisticsList.length; i++){
            if (logisticsList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function addManufacturer(address manAdd) public {
        require (msg.sender == owner);
        manufacturersList.push(manAdd);
    }

    function addDoctor(address docAdd) public {
        require (msg.sender == owner);
        doctorsList.push(docAdd);
    }

    function addSupplier(address supAdd) public {
        require (msg.sender == owner);
        suppliersList.push(supAdd);
    }

    function addPharma(address phaAdd) public {
        require (msg.sender == owner);
        pharmaList.push(phaAdd);
    } 

    function addLogistics(address logAdd) public {
        require (msg.sender == owner);
        logisticsList.push(logAdd);
    }

    function addTokenSymbol(bytes32 symbol, string memory name) public {
        require (msg.sender == owner);
        tokenSymbols.push(symbol);
        tokenSymbolsWithName[symbol] = name;
    }

    function tokenMinter(uint256 tokenCount) public payable {
        require(verifyManufacturer());
        _mint(msg.sender, tokenCount*2);
    }

    function depositTokensToSupplier(uint256 amount, bytes32 symbol, address supplier) public {
        require(verifyManufacturer());
        transferFrom(msg.sender, supplier, amount);
        tokenBalance[symbol] += amount;
    }
    
    function withdrawTokensDoctors(uint256 amount, bytes32 symbol) public {
        require(verifyDoctor());
        require(tokenBalance[symbol] >= amount, "Insufficient Tokens");
        transferFrom(owner, msg.sender, amount);
        emit tokenSent(owner, msg.sender, symbol);
    }

    function transferDoctorToPatient(uint256 tokenCount, address payable patient, bytes32 symbol) public {
        require(verifyDoctor());
        require(tokenBalance[symbol] >= tokenCount, "Insufficient Tokens");
        transferFrom(msg.sender, patient, tokenCount);
        emit tokenSent(msg.sender, patient, symbol);
    }

    function transferManToLog(uint256 tokenCount, address payable log, bytes32 symbol) public {
        require(verifyManufacturer());
        require(tokenBalance[symbol] >= tokenCount, "Insufficient Tokens");
        transferFrom(msg.sender, log, tokenCount);
        emit tokenSent(msg.sender, log, symbol);
    }

    function transferLogToPha(uint256 tokenCount, address payable pha, bytes32 symbol) public {
        require(verifyLogistics());
        require(tokenBalance[symbol] >= tokenCount, "Insufficient Tokens");
        transferFrom(msg.sender, pha, tokenCount);
        emit tokenSent(msg.sender, pha, symbol);
        _burn(pha, tokenCount);
    }

    function transferPatToPha(uint256 tokenCount, address payable pha, bytes32 symbol) public {
        require(tokenBalance[symbol] >= tokenCount, "Insufficient Tokens");
        transferFrom(msg.sender, pha, tokenCount);
        emit tokenSent(msg.sender, pha, symbol);
        _burn(pha, tokenCount);
    }
}