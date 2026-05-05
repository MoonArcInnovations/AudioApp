# Data From Scanned Audiograms

## Current Situation
Only scanned PDF images of audiogram graphs are available, produced by students during practicals.

## Recommended Path
1. Digitize graph images to recover numerical thresholds.
2. Create a simple labeling schema (ear, frequency, threshold, no-response).
3. Store extracted data in a structured CSV or JSON format.
4. Use extracted data to bootstrap rules-based analysis and later ML training.

## Risks
- Scans may be low resolution or skewed, which reduces accuracy.
- Missing metadata (headphones, calibration, ambient noise) limits ML reliability.

## Mitigations
- Standardize scan quality and collection protocol for new data.
- Capture metadata in-app for future tests.
- Keep clinician review in the loop for AI suggestions.

