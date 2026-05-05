# Phase 2: Bone Conduction Hardware Integration (Interacoustics-first)

## Assumption
No vendor API/SDK is currently available. We will target the most common clinical ecosystem first and design a vendor-agnostic control interface to support future integrations.

## Recommended Default Vendor Target
Interacoustics ecosystem (audiometers + OtoAccess/Noah integration) is a common clinical stack globally and is a practical default to start partnership and validation.

## Strategy
### Track A: Direct Device Control (Preferred)
1. Secure vendor partnership and mobile SDK or protocol documentation.
2. Implement device control via platform channels.
3. Validate latency, calibration, and output accuracy.
4. Integrate with BC test UI.

### Track B: Bridge Mode (Fallback)
1. Audiometer connects to a PC running vendor software.
2. PC exports BC results (PDF/XML/HL7).
3. App imports results and links to AC data.
4. Works without mobile SDK, but not direct control.

## Current Implementation (Scaffolding)
- Added vendor-agnostic BC device interface and platform channel stubs:
  - lib/services/bc/bone_conduction_device.dart
  - lib/services/bc/bc_device_channel.dart
  - lib/services/bc/bc_device_provider.dart

## Next Engineering Steps
1. Choose vendor and request SDK/protocol.
2. Implement iOS/Android channel handlers.
3. Wire BC testing UI to the device provider.
4. Store BC thresholds in test_results as testType = 'bone'.
5. Build combined AC+BC report view.

