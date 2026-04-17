// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ApexLogisticsEscrow {
    struct Shipment {
        address farmer;
        address receiver;
        uint256 amount;
        bool isDelivered;
        bytes32 deliveryHash; // This is the "Secret" inside the QR code
    }

    mapping(uint256 => Shipment) public shipments;

    // 1. Create the Shipment (Funds are locked in Escrow)
    function createShipment(uint256 _id, address _receiver, bytes32 _secretHash) public payable {
        shipments[_id] = Shipment(msg.sender, _receiver, msg.value, false, _secretHash);
    }

    // 2. Validate Delivery (The "Scan-to-Pay" Event)
    // The receiver scans the QR code, which provides the 'secretKey'
    function validateDelivery(uint256 _id, string memory _secretKey) public {
        Shipment storage shipment = shipments[_id];
        
        require(!shipment.isDelivered, "Already delivered");
        require(keccak256(abi.encodePacked(_secretKey)) == shipment.deliveryHash, "Invalid QR Code");

        // 3. Automated Settlement (Instant Satisfaction)
        shipment.isDelivered = true;
        payable(shipment.farmer).transfer(shipment.amount);
    }
}
