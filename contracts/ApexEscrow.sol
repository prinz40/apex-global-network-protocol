// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ApexLogisticsEscrow {
    struct Shipment {
        address farmer;
        address receiver;
        uint256 amount;
        bool isDelivered;
        bytes32 deliveryHash; // The "Secret" hash provided during creation
    }

    mapping(uint256 => Shipment) public shipments;

    // 1. Create the Shipment 
    // Funds are sent to the contract and locked until delivery is validated
    function createShipment(uint256 _id, address _receiver, bytes32 _deliveryHash) public payable {
        require(msg.value > 0, "Shipment amount must be greater than 0");
        
        shipments[_id] = Shipment(
            msg.sender, 
            _receiver, 
            msg.value, 
            false, 
            _deliveryHash
        );
    }

    // 2. Validate Delivery (The "Scan-to-Pay" Event)
    // The receiver scans the QR code/provides the secret string to trigger payment
    function validateDelivery(uint256 _id, string memory _secret) public {
        Shipment storage shipment = shipments[_id];

        require(msg.sender == shipment.receiver, "Only the receiver can validate");
        require(!shipment.isDelivered, "Already delivered and paid");
        require(keccak256(abi.encodePacked(_secret)) == shipment.deliveryHash, "Invalid secret code");

        // Mark as delivered
        shipment.isDelivered = true;

        // CRITICAL FIX: Send the locked funds to the farmer
        payable(shipment.farmer).transfer(shipment.amount);
    }

    // Function to check contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
