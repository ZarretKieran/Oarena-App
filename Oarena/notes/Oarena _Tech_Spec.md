# Oarena - Technical Specification Document

**Version:** 1.1
**Date:** July 16, 2024
**Project:** Oarena - Gamified Competitive Virtual Rowing Experience

---

## 1. Introduction

### 1.1. Purpose
This document outlines the technical specifications for Oarena, a mobile application designed to provide a gamified competitive virtual rowing experience. It details the system architecture, components, data models, APIs, key algorithms, and technology stack required to implement the described functionality. This specification will serve as the primary blueprint for the development of Oarena, initially targeting the iOS platform.

### 1.2. Scope
The scope of this document covers:
*   Overall system architecture.
*   iOS mobile application (frontend) design, including UI/UX considerations and PM5 interface module using Swift and SwiftUI.
*   Backend server design, including user management, race logic, leaderboard system, and virtual currency management.
*   Data models for persistent storage.
*   API specifications for frontend-backend communication.
*   Integration with Concept2 PM5 ergometer via Bluetooth Low Energy (BLE) using the CSAFE protocol.
*   In-App Purchase (IAP) integration for "Tickets" on iOS.

### 1.3. Target Audience
This document is primarily intended for the AI development assistant (Gemini 2.5 Pro) and any human developers involved in the Oarena project, particularly those working on the iOS application and backend services.

### 1.4. Referenced Documents
*   Oarena Project Idea & Functionality Description (User-provided)
*   CSAFE Spec.md (User-provided, based on "Concept2 PM CSAFE Communication Definition.doc Rev 0.27")
*   Bluetooth spec.md (User-provided, based on "Concept2 PM Bluetooth Smart Communication Interface Definition.doc Rev 1.30")
*   Concept2_PM5_Interface_Learnings.md (User-provided)

---

## 2. System Architecture

Oarena will employ a client-server architecture:

*   **Mobile Client (iOS Native):** An iOS application built with Swift and SwiftUI, responsible for user interaction, connecting to the Concept2 PM5, displaying real-time race data, and communicating with the backend server.
*   **Backend Server:** A set of APIs and services responsible for user authentication, data persistence (profiles, race results, leaderboards, tickets), race scheduling and management, real-time communication during live races, and IAP validation.
*   **Database:** Persistent storage for all application data.
*   **Real-time Communication Layer:** Facilitates low-latency data exchange for live races (e.g., WebSockets).
*   **Concept2 PM5:** External hardware (ergometer monitor) interfaced via BLE.

```
+---------------------+      +------------------------+      +-------------------+
|   Mobile Client     |<----->| Real-time Comm Layer   |<----->|   Backend Server  |
| (iOS - Swift/SwiftUI)|     | (WebSockets)           |      | (Node.js/Python/Go)|
| - UI/UX (SwiftUI)   |      +------------------------+      | - API Endpoints   |
| - PM5 Interface (CB)|                                        | - Business Logic  |
| - State Mgmt(Combine)|      +------------------------+      | - Auth & User Mgmt|
| - API Client        |      |   Concept2 PM5         |      | - Race Management |
+---------------------+      |   (via BLE)            |      | - Ticket Economy  |
        ^                    +------------------------+      | - Leaderboards    |
        |                                                    +-------------------+
        |                                                            |
        |                                                            v
        +------------------------------------------------------>+-----------+
                                                                | Database  |
                                                                | (PostgreSQL)|
                                                                +-----------+
```

---

## 3. Mobile Application (Frontend) - iOS Native

### 3.1. Technology Stack
*   **Platform:** iOS (Initial Launch)
*   **Development Environment:** Xcode
*   **Language:** Swift
*   **UI Framework:** SwiftUI (utilizing native Apple elements and SF Symbols for icons, or other high-quality icon sets suitable for iOS).
*   **State Management:** SwiftUI's built-in mechanisms (`@State`, `@StateObject`, `@ObservedObject`, `@EnvironmentObject`) and Combine framework for managing asynchronous operations and complex state.
*   **Navigation:** SwiftUI Navigation (`NavigationView`, `NavigationLink`, programmatic navigation).
*   **Bluetooth Communication:**
    *   **CoreBluetooth Framework:** Direct use for BLE scanning, connection, service/characteristic discovery, and data read/write/notify operations.
*   **Local Storage:**
    *   **Core Data:** For structured data like cached user preferences, partial workout logs, or offline race attempts.
    *   **UserDefaults:** For simple user settings (e.g., PM5 connection preference, notification settings).
    *   **File System (FileManager):** For temporary caching of larger data if needed.
*   **Networking:** `URLSession` for API calls. Potentially a lightweight networking layer abstraction.

### 3.2. Key Modules & Screens (SwiftUI Views)

*   **Authentication Module:**
    *   Views: `LoginView`, `RegistrationView`, `ForgotPasswordView`.
    *   Logic: API service calls using `URLSession`, secure token storage in Keychain.
*   **Dashboard/Home Screen (`HomeView`):**
    *   Overview of user stats (rank, tickets), upcoming races, quick start solo training.
*   **PM5 Connection Manager (Persistent UI Element/View):**
    *   Scan for PM5 devices using CoreBluetooth (`CBCentralManager`).
    *   Connect/Disconnect functionality (`connect(_:options:)`, `cancelPeripheralConnection(_:)`).
    *   Display connection status and PM5 info (Serial, Firmware - obtained via CSAFE after connection and service discovery).
    *   Reference `Bluetooth spec.md` for discovery (advertising name "PM5 XXXXXXXXX") and C2 PM Device Information Service (UUID `CE060010-XXXX`).
*   **Solo Training Module (`SoloTrainingView`):**
    *   View: Start/Stop solo session, display real-time metrics from PM5, workout summary.
    *   Logic:
        *   Initiate "JustRow" or a simple fixed workout on PM5 using CSAFE commands (see Appendix A.1).
        *   Subscribe to relevant PM5 data characteristics (e.g., `0x0031`, `0x0032`, `0x0035` - see `Bluetooth spec.md`) using `setNotifyValue(true, for:)`.
        *   Parse incoming data streams in `peripheral(_:didUpdateValueFor:error:)`.
        *   Save workout summary locally (Core Data) and sync with backend to earn tickets.
*   **Race Hub Module (`RaceHubView`):**
    *   Views:
        *   `RaceListingView`: View available scheduled races (live/asynchronous), filter by type/entry fee.
        *   `RaceDetailView`: Information about a specific race, participant list, prize structure.
        *   `ScheduleRaceView`: Form to create new races (one-on-one, group, tournament bracket view).
        *   `MyRacesView`: List of races the user is registered for or has participated in.
    *   Logic: API calls to fetch/create/join races. Manage "Ticket" payment for entry.
*   **Live Race Module (`LiveRaceView`):**
    *   View: Real-time display of user's performance, positions of other racers (ghosts or simplified progress bars), countdown, finish screen.
    *   Logic:
        *   Set up race on PM5 using CSAFE commands (see Appendix A.1 for workout setup sequence).
        *   Stream PM5 data to backend via WebSocket.
        *   Receive real-time updates for other racers from backend via WebSocket.
*   **Asynchronous Race Module (`AsyncRaceView`):**
    *   View: Start pre-defined race course, submit results.
    *   Logic: Set up race on PM5, log performance, submit final data to backend.
*   **Leaderboard Module (`LeaderboardView`):**
    *   Views: Display global, regional (if implemented), and friends' leaderboards. Filter by rank tiers.
    *   Logic: API calls to fetch leaderboard data.
*   **Profile Module (`ProfileView`):**
    *   Views: View/edit user profile, race history, stats (PBs, average metrics), rank progression.
*   **Shop Module (Tickets) (`StoreView`):**
    *   View: Display "Ticket" packages for purchase.
    *   Logic: Integrate with StoreKit for IAP. Server-side validation of purchases.
*   **Settings Module (`SettingsView`):**
    *   App preferences, notification settings, link/unlink PM5, logout.

### 3.3. PM5 Interface Module (CSAFE Communication Layer - Swift Class/Structs)

This is a critical component within the mobile app, implemented in Swift.

*   **Core Functionality (Implemented using CoreBluetooth):**
    *   `CBCentralManager` for managing BLE state, scanning (`scanForPeripherals(withServices:options:)`), and connecting.
        *   Discovery approach: Scan without service filters and match devices by `CBAdvertisementDataLocalNameKey` containing "PM5" or by presence of Concept2 service UUIDs. This improves discovery reliability for PM5s that don't advertise services in scan responses.
    *   `CBPeripheral` for interacting with the connected PM5.
    *   `CBPeripheralDelegate` methods for service discovery (`discoverServices(_:)`, `peripheral(_:didDiscoverServices:)`), characteristic discovery (`discoverCharacteristics(_:for:)`, `peripheral(_:didDiscoverCharacteristicsFor:error:)`), and value updates (`peripheral(_:didUpdateValueFor:error:)`, `peripheral(_:didWriteValueFor:error:)`).
    *   Service and Characteristic discovery:
        *   Target specific CBUUIDs for Concept2 services and characteristics as defined in `Bluetooth spec.md`.
        *   **C2 PM Control Service (CBUUID string `CE060020-43E5-11E4-916C-0800200C9A66`):**
            *   C2 PM Receive Characteristic (CBUUID string `CE060021-XXXX`): For sending CSAFE command frames (`writeValue(_:for:type:.withResponse)`).
            *   C2 PM Transmit Characteristic (CBUUID string `CE060022-XXXX`): For receiving CSAFE response frames (`readValue(for:)` or `setNotifyValue(true, for:)` - typically `readValue` after a command, or notify if PM5 pushes status).
        *   **C2 PM Rowing Service (CBUUID string `CE060030-XXXX`):**
            *   Subscribe to relevant data characteristics (`0x0031` to `0x003A`, `0x003D`, etc.) using `setNotifyValue(true, for:)`.
            *   Use C2 rowing general status and additional status sample rate characteristic (`0x0034`) to set data update frequency.
        *   Also discover standard Device Information Service (`180A`) for optional device metadata.
    *   CSAFE Frame Construction (Swift functions to generate `Data` objects):
        *   Implement logic from `CSAFE Spec.md` Section "Frame Structure".
        *   Standard Start Flag (`0xF1`), Stop Frame Flag (`0xF2`).
        *   Checksum calculation (XOR byte-by-byte of Frame Contents).
        *   Byte Stuffing (`0xF3` flag for `0xF0, 0xF1, 0xF2, 0xF3`).
        *   Command Wrappers (e.g., `CSAFE_SETPMCFG_CMD (0x76)`).
    *   CSAFE Response Parsing (Swift functions to parse `Data` objects):
        *   Parse status byte.
        *   Extract data from command responses.
    *   Command Sequencing & State Management (Crucial - based on `Concept2_PM5_Interface_Learnings.md`):
        *   Maintain an internal state machine (e.g., Swift `enum` with associated values) for CSAFE interactions.
        *   Implement sequential command sending for workout setup using async/await with Combine publishers or completion handlers.
        *   Introduce configurable delays (e.g., `DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)`) between sending commands.
        *   Handle PM5 error codes and CSAFE status errors.
    *   Data Parsing from Notifications:
        *   Deconstruct `Data` objects from characteristics into metrics using Swift's data handling capabilities (e.g., `Data` subscripting, bitwise operations, type casting after byte reordering).
        *   Convert raw bytes to metrics as detailed in specifications:
            *   Time: 3 bytes (Lo, Mid, Hi) in 0.01s units.
            *   Distance: 3 bytes (Lo, Mid, Hi) in 0.1m units.
            *   Pace: 2 bytes in 0.01s units.
            *   Power: 2 bytes in watts.
            *   Stroke Rate: 1 byte.
            *   Calories: 2 bytes.
            *   Drag Factor: 1 byte.

### 3.4. User Experience (UX) Considerations
*   **Native iOS Look and Feel:** Adherence to Apple's Human Interface Guidelines (HIG). Use of SF Symbols and standard SwiftUI controls where appropriate.
*   **Smooth Animations & Transitions:** Leverage SwiftUI's animation capabilities for a polished experience.
*   **Clear PM5 Connection Status:** Always visible when relevant.
*   **Responsive Real-time Data:** Smooth updates during rowing, displayed clearly.
*   **Intuitive Race Setup:** Easy to understand forms with clear instructions.
*   **Minimal Latency in Live Races:** Optimize data flow and UI updates.
*   **Informative Error Handling:** User-friendly alerts and messages for PM5 communication errors or backend issues, specific to iOS.
*   **Ticket Transparency:** Clear display of ticket balance and costs.
*   **Accessibility:** Implement support for VoiceOver, Dynamic Type, and other iOS accessibility features.

---

## 4. Backend Server

### 4.1. Technology Stack
*   **Language/Framework:** Node.js with Express.js or NestJS (excellent for I/O-bound and real-time applications). Alternatives: Python (Django/Flask), Go.
*   **Database:** PostgreSQL (strong relational integrity, good for structured data like user profiles, races, and leaderboards).
*   **Real-time Communication:** Socket.IO (integrates well with Node.js) or raw WebSockets.
*   **Authentication:** JWT (JSON Web Tokens) for stateless API authentication. OAuth 2.0 for Sign in with Apple (mandatory for iOS if other social logins are offered).
*   **Caching:** Redis for frequently accessed data (e.g., leaderboards, active race details).
*   **IAP Validation:** Libraries/logic for Apple App Store server-to-server notifications and receipt validation.

### 4.2. Key Modules & Functionality

*   **User Authentication & Management Module:**
    *   Endpoints for registration, login, password reset, profile updates.
    *   Secure password hashing (e.g., bcrypt).
    *   Manages user sessions/tokens.
    *   Support for Sign in with Apple.
*   **Race Management Module:**
    *   **Scheduling:**
        *   Endpoints to create races (one-on-one, group, tournament shells).
        *   Store race definitions: type, start time, entry fee (Tickets), prize structure, participants.
    *   **Joining:**
        *   Endpoints for users to join races (deducts Tickets).
    *   **Live Race Logic:**
        *   WebSocket server to handle connections from multiple clients in a race.
        *   Receive performance data from each client.
        *   Broadcast aggregated/relevant data to all participants in the race (e.g., positions, current leader).
        *   Determine winners based on finish times/conditions.
        *   Distribute prizes (Tickets).
    *   **Asynchronous Race Logic:**
        *   Endpoints to submit asynchronous race results.
        *   Store results, compare, and determine winners after race window closes.
        *   Distribute prizes.
    *   **Tournament Logic:**
        *   Manage tournament brackets, progression of winners, scheduling subsequent rounds.
*   **Leaderboard & Ranking Module:**
    *   Calculate Ranking Points (RP) / Matchmaking Rating (MMR) based on race outcomes. Consider an Elo-like system:
        *   `NewRating = OldRating + K * (ActualScore - ExpectedScore)`
        *   `K-factor` can vary based on rank or number of races played.
        *   `ExpectedScore` depends on rating difference between opponents.
    *   Store and update user ranks and RP/MMR.
    *   Endpoints to fetch leaderboard data (global, regional, friends) with pagination and filtering.
    *   Handle rank tier promotions/demotions and seasonal resets (if implemented).
*   **Ticket Economy Module:**
    *   Track user "Ticket" balances.
    *   Logic for awarding Tickets:
        *   Winning competitions (defined by race prize structure).
        *   Solo training: Algorithm based on workout volume (distance/time) and intensity (average pace/power).
            *   `TicketsEarned = (k_dist * distance) + (k_time * time_seconds) + (k_intensity_pace * (1 / avg_pace_seconds_per_500m)) + (k_intensity_power * avg_power_watts)`
            *   Coefficients (k_*) need careful balancing to prevent inflation and incentivize varied training.
            *   Implement daily/weekly caps on earnable tickets from solo training.
    *   Logic for deducting Tickets (race entry).
    *   Endpoints for IAP:
        *   Provide list of Ticket packages.
        *   Endpoint to receive purchase receipts from iOS client for server-side validation with Apple App Store.
        *   Credit Tickets to user account upon successful validation.
*   **Solo Training Log Module:**
    *   Endpoints to receive completed solo workout data from mobile clients.
    *   Store workout summaries.
    *   Trigger Ticket earning logic.
*   **Notifications Module (Apple Push Notification service - APNs):**
    *   Race start reminders, new race invitations, rank updates.

---

## 5. Data Models (PostgreSQL)

*(Simplified - primary keys are typically `id BIGSERIAL PRIMARY KEY`)*

*   **`users`**
    *   `id`: BIGSERIAL, PK
    *   `username`: VARCHAR(255), UNIQUE, NOT NULL
    *   `email`: VARCHAR(255), UNIQUE, NOT NULL
    *   `password_hash`: VARCHAR(255), NOT NULL
    *   `apple_user_id`: VARCHAR(255), UNIQUE, NULLABLE (for Sign in with Apple)
    *   `tickets_balance`: INTEGER, DEFAULT 0, NOT NULL
    *   `ranking_points (rp)`: INTEGER, DEFAULT 1000, NOT NULL
    *   `rank_tier`: VARCHAR(50), DEFAULT 'Bronze'
    *   `pm5_serial_number_linked`: VARCHAR(50), NULLABLE
    *   `created_at`: TIMESTAMPZ, DEFAULT NOW()
    *   `updated_at`: TIMESTAMPZ, DEFAULT NOW()

*   **`races`**
    *   `id`: BIGSERIAL, PK
    *   `name`: VARCHAR(255), NOT NULL
    *   `race_type`: VARCHAR(50) ('ONE_ON_ONE', 'GROUP', 'TOURNAMENT_ROUND', 'ASYNC')
    *   `status`: VARCHAR(50) ('SCHEDULED', 'LIVE', 'COMPLETED', 'CANCELLED')
    *   `scheduled_at`: TIMESTAMPZ, NOT NULL
    *   `entry_fee_tickets`: INTEGER, DEFAULT 0
    *   `prize_tickets_winner`: INTEGER, DEFAULT 0
    *   `prize_structure_json`: JSONB (for more complex group race prizes)
    *   `max_participants`: INTEGER, NULLABLE
    *   `workout_definition_type`: VARCHAR(50) ('FIXED_DISTANCE', 'FIXED_TIME')
    *   `workout_goal_value`: INTEGER (meters or centiseconds)
    *   `workout_split_value`: INTEGER (meters or centiseconds)
    *   `created_by_user_id`: BIGINT, FK to `users(id)`
    *   `created_at`: TIMESTAMPZ, DEFAULT NOW()

*   **`race_participants`**
    *   `id`: BIGSERIAL, PK
    *   `race_id`: BIGINT, FK to `races(id)`
    *   `user_id`: BIGINT, FK to `users(id)`
    *   `status`: VARCHAR(50) ('REGISTERED', 'COMPLETED', 'DNF')
    *   `finish_time_cs`: INTEGER, NULLABLE (centiseconds)
    *   `finish_rank`: INTEGER, NULLABLE
    *   `rp_change`: INTEGER, NULLABLE
    *   `tickets_won`: INTEGER, DEFAULT 0
    *   `workout_data_summary_json`: JSONB (full workout log if needed)
    *   `joined_at`: TIMESTAMPZ, DEFAULT NOW()
    *   UNIQUE (`race_id`, `user_id`)

*   **`solo_workouts`**
    *   `id`: BIGSERIAL, PK
    *   `user_id`: BIGINT, FK to `users(id)`
    *   `workout_type`: VARCHAR(50) (e.g., 'JUST_ROW', 'FIXED_DISTANCE_SOLO')
    *   `total_distance_m`: INTEGER
    *   `total_time_cs`: INTEGER
    *   `avg_pace_cs_500m`: INTEGER
    *   `avg_power_watts`: INTEGER
    *   `avg_stroke_rate`: INTEGER
    *   `drag_factor_avg`: INTEGER
    *   `tickets_earned`: INTEGER, DEFAULT 0
    *   `workout_data_full_json`: JSONB (detailed split/stroke data if needed)
    *   `completed_at`: TIMESTAMPZ, DEFAULT NOW()

*   **`ticket_transactions`**
    *   `id`: BIGSERIAL, PK
    *   `user_id`: BIGINT, FK to `users(id)`
    *   `transaction_type`: VARCHAR(50) ('RACE_ENTRY', 'RACE_WIN', 'SOLO_TRAINING', 'IAP_PURCHASE', 'ADMIN_ADJUST')
    *   `amount`: INTEGER (positive for credit, negative for debit)
    *   `related_race_id`: BIGINT, FK to `races(id)`, NULLABLE
    *   `related_solo_workout_id`: BIGINT, FK to `solo_workouts(id)`, NULLABLE
    *   `related_iap_id`: BIGINT, FK to `iap_purchases(id)`, NULLABLE
    *   `transaction_date`: TIMESTAMPZ, DEFAULT NOW()

*   **`iap_purchases`**
    *   `id`: BIGSERIAL, PK
    *   `user_id`: BIGINT, FK to `users(id)`
    *   `platform`: VARCHAR(10), DEFAULT 'IOS', NOT NULL
    *   `product_id_apple`: VARCHAR(255) (e.g., 'com.oarena.tickets.100')
    *   `original_transaction_id_apple`: VARCHAR(255), UNIQUE
    *   `latest_receipt_data_apple`: TEXT
    *   `status`: VARCHAR(50) ('PENDING_VALIDATION', 'VALIDATED', 'FAILED_VALIDATION', 'REFUNDED')
    *   `tickets_credited`: INTEGER
    *   `purchase_date`: TIMESTAMPZ
    *   `validation_date`: TIMESTAMPZ, NULLABLE

---

## 6. API Design (RESTful & WebSockets)

### 6.1. Authentication (`/auth`)
*   `POST /auth/register` (email, username, password) -> `{ token, user }`
*   `POST /auth/login` (email/username, password) -> `{ token, user }`
*   `POST /auth/apple` (identityToken, fullName (optional)) -> `{ token, user }` (for Sign in with Apple)
*   `POST /auth/refresh-token` (refreshToken) -> `{ token }`

### 6.2. Users (`/users`)
*   `GET /users/me` (Auth required) -> User profile details
*   `PUT /users/me` (Auth required) -> Update user profile
*   `GET /users/{userId}/profile` -> Public profile of a user

### 6.3. Races (`/races`)
*   `POST /races` (Auth required, body: race_details) -> Create new race
*   `GET /races` -> List available races (with filters: type, status, entry_fee)
*   `GET /races/{raceId}` -> Get details of a specific race
*   `POST /races/{raceId}/join` (Auth required) -> Join a race (deducts tickets)
*   `POST /races/{raceId}/start` (Auth required, for race creator/admin) -> Mark race as LIVE
*   `POST /races/{raceId}/submit-async` (Auth required, body: workout_summary) -> Submit async race result
*   `GET /users/me/races` (Auth required) -> List races user is part of

### 6.4. Solo Workouts (`/workouts/solo`)
*   `POST /workouts/solo` (Auth required, body: workout_summary_data) -> Log a solo workout, earn tickets

### 6.5. Leaderboards (`/leaderboards`)
*   `GET /leaderboards/global` (query params: page, limit, rank_tier) -> Global leaderboard
*   `GET /leaderboards/friends` (Auth required, query params: page, limit) -> Friends leaderboard

### 6.6. Shop/IAP (`/store`)
*   `GET /store/ticket-packages` -> List available ticket packages
*   `POST /store/validate-purchase/ios` (Auth required, body: { receiptData, productId, transactionId }) -> Validate iOS IAP

### 6.7. WebSocket Events (Namespace: `/live-race`)

*   **Client to Server:**
    *   `join_race_room` (payload: `{ raceId, userId, token }`)
    *   `pm5_data_update` (payload: `{ raceId, userId, distance, time, pace, power, strokeRate, currentSplit }`)
    *   `finish_race` (payload: `{ raceId, userId, finalTime_cs }`)
*   **Server to Client:**
    *   `race_countdown_start` (payload: `{ startTimeEpoch }`)
    *   `participant_data_update` (payload: `[{ userId, distance, pace, position_in_race }]`)
    *   `participant_finished` (payload: `{ userId, finalTime_cs, rank }`)
    *   `race_results_final` (payload: `[{ userId, finalTime_cs, rank, rpChange, ticketsWon }]`)
    *   `error_message` (payload: `{ message }`)

---

## 7. Non-Functional Requirements

*   **Performance:**
    *   Live race data updates should have <500ms latency.
    *   API responses generally <200ms.
    *   PM5 data polling/notification rate: 250-500ms.
*   **Scalability:** Backend designed to handle concurrent users, especially during peak race times. Cloud-native deployment.
*   **Security:**
    *   HTTPS for all API communication.
    *   Secure token-based authentication (JWT).
    *   Input validation on all API endpoints.
    *   Protection against common web vulnerabilities (OWASP Top 10).
    *   Secure IAP receipt validation (server-side with Apple).
*   **Reliability:**
    *   Robust error handling for PM5 communication.
    *   Graceful degradation if backend services are temporarily unavailable.
*   **Usability:** Intuitive and responsive UI adhering to Apple HIG. Clear feedback to the user.

---

## 8. Deployment

*   **Backend & Database:** Cloud platform (e.g., AWS EC2/RDS/Elastic Beanstalk, GCP App Engine/Cloud SQL, Azure App Service/SQL Database). Containerization (Docker, Kubernetes) for scalability.
*   **Mobile App (iOS):** Distribution via Apple App Store. TestFlight for beta testing.
*   **CI/CD:** Pipelines for automated testing (XCTest for iOS) and deployment (e.g., Xcode Cloud, Fastlane, Bitrise).

---

## 9. Future Considerations

*   Advanced analytics for user performance.
*   More complex tournament formats.
*   Social features: Friends system, direct challenges, in-app chat.
*   Customizable avatars or erg skins (virtual items).
*   Integration with other fitness platforms (e.g., Apple HealthKit).
*   **watchOS Companion App:** For quick stats, race notifications, or basic workout controls.
*   **Android Port:** Future development for the Android platform.

---

## Appendix A: Key CSAFE Command Sequences

### A.1. PM5 Workout Setup (Fixed Time/Distance with Splits)

This sequence is based on `Concept2_PM5_Interface_Learnings.md` and utilizes sequential `CSAFE_SETPMCFG_CMD (0x76)` wrapped commands. A delay of ~300ms is recommended between sending each frame.

1.  **Set Workout Type:**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x01, Length=0x01, WorkoutTypeValue]`
        *   `WorkoutTypeValue`:
            *   Fixed Time w/ Splits: `0x05` (CSAFE_PM_WORKOUTTYPE_FIXEDTIME_NOSPLITS)
            *   Fixed Dist w/ Splits: `0x03` (CSAFE_PM_WORKOUTTYPE_FIXEDDIST_SPLITS)

2.  **Set Total Workout Duration/Distance:**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x03 (CSAFE_PM_SET_WORKOUTDURATION), Length=0x05, DurationIdentifier, Value_Byte3, Value_Byte2, Value_Byte1, Value_Byte0 (LSB)]`
        *   `DurationIdentifier`: `0x00` for Time (Value in centiseconds), `0x80` for Distance (Value in meters).
        *   Value is 4 bytes.

3.  **Set Split Duration/Distance:**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x05 (CSAFE_PM_SET_SPLITDURATION), Length=0x05, DurationIdentifier, Value_Byte3, Value_Byte2, Value_Byte1, Value_Byte0 (LSB)]`
        *   `DurationIdentifier`: `0x00` for Time (Value in centiseconds), `0x80` for Distance (Value in meters).
        *   Value is 4 bytes.

4.  **Configure Workout (Enable Programming Mode):**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x14 (CSAFE_PM_CONFIGURE_WORKOUT), Length=0x01, Enable=0x01]`

5.  **Set Screen State (Show Workout Screen):**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x13 (CSAFE_PM_SET_SCREENSTATE), Length=0x02, ScreenType=0x01 (SCREENTYPE_WORKOUT), ScreenValue=0x01 (SCREENVALUEWORKOUT_PREPARETOROWWORKOUT)]`

**Note:** Omit `CSAFE_GOIDLE_CMD`, `CSAFE_RESET_CMD`, and `CSAFE_GOINUSE_CMD` from this sequence. The PM5 should be ready to row after Step 5.

### A.2. "Just Row" Setup (Solo Training)
1.  **Set Workout Type to JustRow (with splits for data):**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x01 (CSAFE_PM_SET_WORKOUTTYPE), Length=0x01, WorkoutTypeValue=0x01 (WORKOUTTYPE_JUSTROW_SPLITS)]`

2.  **Set Screen State (Show Workout Screen):**
    *   Wrapper: `0x76`
    *   Payload: `[ParamID=0x13 (CSAFE_PM_SET_SCREENSTATE), Length=0x02, ScreenType=0x01 (SCREENTYPE_WORKOUT), ScreenValue=0x01 (SCREENVALUEWORKOUT_PREPARETOROWWORKOUT)]`

### A.3. Get PM5 Data (Example - Get Drag Factor)
1.  **Request Drag Factor:**
    *   Wrapper: `CSAFE_GETPMDATA_CMD (0x7F)` (or `CSAFE_SETUSERCFG1_CMD (0x1A)` as per some examples in CSAFE spec for short proprietary commands). Prefer `0x7F` for "get data".
    *   Payload: `[CommandID=0xC1 (CSAFE_PM_GET_DRAGFACTOR)]`
    *   Expected Response (within wrapper): `[CommandID=0xC1, Length=0x01, DragFactorValue]`
