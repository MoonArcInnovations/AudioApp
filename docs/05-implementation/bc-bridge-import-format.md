# BC Bridge Import Format (Generic XML/HL7)

## Purpose
Provide a minimal, generic format the parser can understand without vendor SDKs.

## XML Format (Supported)
The parser looks for elements named `threshold`, `point`, or `result` with attributes:
- frequency / freq / hz
- db / threshold / value

Ear can be indicated by:
- parent element name containing `right` or `left`
- attribute `side` or `ear` with values starting with R/L

### Example
```xml
<audiogram>
  <ear side="right">
    <threshold frequency="1000" db="20" />
    <threshold frequency="2000" db="25" />
  </ear>
  <ear side="left">
    <threshold frequency="1000" db="15" />
    <threshold frequency="2000" db="20" />
  </ear>
</audiogram>
```

## HL7 Format (Supported)
The parser scans OBX segments:
- It extracts frequency from OBX-3 or OBX-5 if it finds a number like `1000`.
- It extracts threshold dB from OBX-5.
- It infers ear from text in OBX-3 or segment containing `RIGHT`/`LEFT` or `EAR:R`/`EAR:L`.

### Example (Simplified)
```
OBX|1|NM|FREQ_1000_RIGHT|1|20|dB HL
OBX|2|NM|FREQ_2000_RIGHT|1|25|dB HL
OBX|3|NM|FREQ_1000_LEFT|1|15|dB HL
OBX|4|NM|FREQ_2000_LEFT|1|20|dB HL
```

## Result
If thresholds are parsed, the system writes a `test_results` record with:
- testType = "bone"
- right/left ear thresholds
- PTA + classifications

If parsing fails, the import status is marked `failed` with a note.

