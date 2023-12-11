// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the previously defined 'MediBloc' contract to link medicine records with patient records.
// import "./MediBloc.sol";

contract MedicineTracking {

    // Structure to represent a medicine record.
    struct MedicineRecord {
        uint256 medicineId;
        string medicineName;
        uint256 quantity;
        address prescribedBy;
        bool isDispensed;
    }

    // Mapping to associate each patient with their medicine records.
    mapping(address => MedicineRecord[]) public patientMedicines;

    // Event to log the creation of a new medicine record.
    event MedicineRecordCreated(address indexed patient, uint256 medicineId, string medicineName);

    // Reference to the 'MediBloc' contract.
    MediBloc private mediBlocContract;

    // Constructor to link with the 'MediBloc' contract.
    constructor(address _mediBlocContract) {
        mediBlocContract = MediBloc(_mediBlocContract);
    }

    // Function to create a medicine record for a patient.
    function createMedicineRecord(
        uint256 _medicineId,
        string memory _medicineName,
        uint256 _quantity
    ) public {
        // Retrieve the patient's Ethereum address.
        address patientAddress = msg.sender;

        // Ensure the patient has a medical record in 'MediBloc'.
        require(mediBlocContract.hasMedicalRecord(patientAddress), "Patient does not have a medical record.");

        // Create a new medicine record.
        MedicineRecord memory record;
        record.medicineId = _medicineId;
        record.medicineName = _medicineName;
        record.quantity = _quantity;
        record.prescribedBy = msg.sender;
        record.isDispensed = false;

        // Add the medicine record to the patient's list.
        patientMedicines[patientAddress].push(record);

        // Emit an event to log the creation of the medicine record.
        emit MedicineRecordCreated(patientAddress, _medicineId, _medicineName);
    }

    // Function to dispense a medicine.
    function dispenseMedicine(uint256 _medicineId) public {
        MedicineRecord[] storage patientMedicineList = patientMedicines[msg.sender];

        // Search for the medicine record.
        for (uint i = 0; i < patientMedicineList.length; i++) {
            if (patientMedicineList[i].medicineId == _medicineId) {
                require(!patientMedicineList[i].isDispensed, "Medicine is already dispensed.");

                // Mark the medicine as dispensed.
                patientMedicineList[i].isDispensed = true;
                return;
            }
        }

        revert("Medicine record not found.");
    }
}
