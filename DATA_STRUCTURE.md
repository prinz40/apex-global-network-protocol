# Apex Global Network: Data Structure v1.0

### The Apex Shipment Object (ASO)
Every international shipment on the network is represented by an ASO containing:

1. **Public Metadata (Visible to all)**:
   - Unique Apex Tracking ID
   - Current Custodian (Who has the package now?)
   - Timestamp of last update
   - Status (Origin, In-Transit, Customs, Delivered)

2. **Private Encrypted Data (Visible only to Sender/Receiver)**:
   - Itemized manifest (What is inside?)
   - Commercial value for insurance
   - Detailed receiver contact information

3. **Validation Proofs**:
   - Digital signatures from every handler in the supply chain.
   - GPS coordinate hash (proving the location without exposing the exact route).

### Consensus Mechanism
The network uses **Proof of Authority (PoA)** for logistics handlers to ensure that only verified shipping agents can update the status of a global crate.
