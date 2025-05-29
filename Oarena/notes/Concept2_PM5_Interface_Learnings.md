# Concept2 PM5 CSAFE How-To

## 1. Frame Construction & Protocol
- All communication uses CSAFE frames (see "Frame Structure" in @CSAFE Spec.md).
- Use correct start/stop flags, byte-stuffing, and checksum as specified.
- Multiple commands can be sent in a single frame; responses will be in the same order.

---

## 2. Setting Up a Workout
**Always use sequential commands with ~300ms delay between each. Omit `CSAFE_GOIDLE_CMD`, `CSAFE_RESET_CMD`, and `CSAFE_GOINUSE_CMD`.**

### Basic Sequence (for Fixed Time/Distance/Splits):
1. **Set Workout Type**
   - Command: `CSAFE_SETPMCFG_CMD (0x76)`
   - Payload: `[0x01, 0x01, WorkoutTypeValue]`
     - E.g., Fixed Time: `0x05`, Fixed Distance: `0x03` (see @CSAFE Spec.md for all types)
2. **Set Total Duration/Distance**
   - Command: `CSAFE_SETPMCFG_CMD (0x76)`
   - Payload: `[0x03, 0x05, DurationIdentifier, Value(4 bytes LSB)]`
     - Time: `DurationIdentifier = 0x00`, value in centiseconds
     - Distance: `DurationIdentifier = 0x80`, value in meters
3. **Set Split Duration/Distance**
   - Command: `CSAFE_SETPMCFG_CMD (0x76)`
   - Payload: `[0x05, 0x05, DurationIdentifier, Value(4 bytes LSB)]`
4. **Configure Workout**
   - Command: `CSAFE_SETPMCFG_CMD (0x76)`
   - Payload: `[0x14, 0x01, 0x01]`
5. **Set Screen State**
   - Command: `CSAFE_SETPMCFG_CMD (0x76)`
   - Payload: `[0x13, 0x02, 0x01, 0x01]` (Workout screen, prepare to row)

**See @CSAFE Spec.md "Sample Functionality" for full byte examples.**

---

## 3. Monitoring/Reading Real-Time Workout Data

### A. Use CSAFE_GETPMDATA_CMD (0x7F) as a wrapper for PM-specific "get" commands.
- Send a frame with `CSAFE_GETPMDATA_CMD` and one or more of the following:
  - `CSAFE_PM_GET_WORKOUTSTATE (0x8D)` – Current workout state
  - `CSAFE_PM_GET_WORKOUTTYPE (0x89)` – Workout type
  - `CSAFE_PM_GET_INTERVALTYPE (0x8E)` – Interval type
  - `CSAFE_PM_GET_WORKTIME (0xA0)` – Elapsed time
  - `CSAFE_PM_GET_WORKDISTANCE (0xA3)` – Distance
  - `CSAFE_PM_GET_DRAGFACTOR (0xC1)` – Drag factor
  - `CSAFE_PM_GET_STROKERATESTATE (0xC0)` – Stroke state
  - `CSAFE_PM_GET_RESTTIME (0xCF)` – Rest time
  - ...and others as needed (see @CSAFE Spec.md, "C2 Proprietary Short Get Data Commands")
- **Polling:** Query these at 250–500ms intervals for real-time updates.

### B. Data Parsing
- Multi-byte values are LSB first (see "DATA CONSTRUCTION" in @CSAFE Spec.md).
- Example: 4-byte time = (MSB, ..., LSB), combine as specified.

---

## 4. Error Handling
- Always check the status byte in responses.
  - `0x81`: Capability Error (parameter out of range or wrong state)
  - `0x91`: Invalid Parameter Error
- Log both PM5 display errors and CSAFE status bytes.

---

## 5. State Management
- Track PM5 state internally (see "Workout State" and "State Machine State" in @CSAFE Spec.md).
- Only start new workout setup if PM5 is in "Ready" or previous sequence is complete.

---

## 6. Reference
- For full command/response details, enumerations, and byte layouts, see @CSAFE Spec.md.
- For troubleshooting, see "Key Learnings" at the top of this document.

---

**This document, together with @CSAFE Spec.md, is all you need to construct robust PM5 CSAFE interfaces for both workout setup and real-time monitoring.** 