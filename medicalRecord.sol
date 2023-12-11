// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract MediBloc {
    struct MedicalRecord {
        string patientName;
        uint256 birthDate;
        string diagnosis;
        string treatment;
        address createdBy;  // The healthcare provider's Ethereum address
    }

    mapping(address => MedicalRecord) public patientRecords;

    event MedicalRecordCreated(address indexed patient, string patientName);

    function createMedicalRecord(
        string memory _patientName,
        uint256 _birthDate,
        string memory _diagnosis,
        string memory _treatment
    ) public {
        require(bytes(_patientName).length > 0, "Patient name cannot be empty");

        MedicalRecord storage record = patientRecords[msg.sender];
        record.patientName = _patientName;
        record.birthDate = _birthDate;
        record.diagnosis = _diagnosis;
        record.treatment = _treatment;
        record.createdBy = msg.sender;

        emit MedicalRecordCreated(msg.sender, _patientName);
    }
}
