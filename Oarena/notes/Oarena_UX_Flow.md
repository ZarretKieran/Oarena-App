# Oarena UX Flow Document (Revised)

This document outlines the user experience (UX) flow for the Oarena application, detailing navigation, menus, UI elements, and user interactions. The goal is to create a streamlined, intuitive, fun, and engaging experience for Concept2 PM5 users.

## Style Guide
Consult @Oarena_Creative_Guidelines.md in the @notes folder for stylistic guidelines.

## 1. Overall App Structure & Navigation

Oarena uses a **Tab Bar navigation** system for quick access to main sections, aligning with native iOS design for an intuitive experience.

### 1.1. Main Tab Bar Sections:

The bottom Tab Bar features:

1.  **Home:** Personalized dashboard and landing screen.
2.  **Train:** Solo training sessions and workout logging.
3.  **Race:** Hub for all competitive racing.
4.  **Rankings:** Leaderboards and user ranking; the competitive game aspect.
5.  **Profile:** Account details, settings, history, and stats.

A persistent **PM5 Connection Status Indicator** (a small, tappable card) will be visible at the top of "Train" and "Race" screens.

### 1.2. Navigation Principles:

*   **Hierarchy:** Clear visual structure for nested content.
*   **Consistency:** Uniform UI elements and interaction patterns.
*   **Feedback:** Immediate visual (and occasional haptic) responses to actions.
*   **Efficiency:** Minimized taps for common actions.
*   **Engagement:** Warm colors, sporty icons (SF Symbols, custom for brand), smooth SwiftUI animations, and extensive use of card-based UI for a "fun and sporty vibe." Exclusively native iOS SwiftUI elements.

## 2. Detailed UX Flows per Section

---

### 2.1. User Onboarding (Login/Registration)

**Goal:** Smooth, secure account creation and login.
**Trigger:** First app launch or after logout.

**Flow:**

1.  **Launch Screen:** Oarena logo, tagline. Buttons: "Sign Up," "Log In." Options: "Sign in with Apple," "Sign up with Google."
    *   **UI:** Standard Buttons, Logo Image View.

2.  **Sign Up Screen (`RegistrationView` - Modal):**
    *   Fields: Email, Password, Confirm Password, Username (unique).
    *   Button: "Create Account." Link: "Already have an account? Log In."
    *   Error handling: Inline validation (email, password strength, username).
    *   **UI:** TextFields, SecureFields, Button, Text links.

3.  **Log In Screen (`LoginView` - Modal):**
    *   Fields: Email/Username, Password.
    *   Button: "Log In." Links: "Forgot Password?," "Don't have an account? Sign Up."
    *   **UI:** TextFields, SecureField, Buttons, Text links.

4.  **Forgot Password Screen (`ForgotPasswordView` - Modal):**
    *   Field: Email. Button: "Send Reset Link." Instructions.
    *   **UI:** TextField, Button, Text.

**Post Onboarding:** Successful login/signup navigates to the **Home** tab.

---

### 2.2. PM5 Connection Management

**Goal:** Easy, reliable Concept2 PM5 connection.

**Persistent Element:**
*   The **PM5 Connection Status Indicator** (e.g., a card: green for connected, red for disconnected, yellow for attempting) appears at the top of "Train" and "Race" tabs.
*   Tapping opens an action sheet showing connection status, listing available PM5s, or allowing re-scan.

**Flow:**

1.  **Automatic Scan (Background):** App gently scans for known PM5s on start (if Bluetooth permitted).

2.  **Manual Scan/Connect (`PM5ConnectionView`):**
    *   **Trigger:** Via Profile > Settings, a prompt before Train/Race without connection, or tapping the status indicator.
    *   **Screen:** Lists discovered PM5s (by PM5 ID, e.g., "PM5 XXXXXXXX"). "Scanning..." indicator. Button: "Refresh Scan."
        *   **UI:** List rows with PM5 ID and "Connect" button. Ensure ample padding/spacing.
    *   **Process:** Tap "Connect." App attempts connection (displays "Connecting...", "Authenticating...", "Connected!"). Status indicator updates.
    *   **UI:** Indicator card color changes.
    *   **Post-Connection:** Status indicator updates. User can proceed with Train/Race.

3.  **Disconnection:** Via status indicator action sheet or `PM5ConnectionView`. Automatic if PM5 off/out of range. App updates indicator gracefully.

---

### 2.3. Home Tab (`HomeView`)

**Goal:** Personalized overview, quick actions, engaging content using well-spaced card-based UI.

**Content & Sections (Cards):**

0.  **Ticket Counter:** At the top. Tapping navigates to `StoreView` (see 2.8) for ticket purchases.

1.  **Welcome & User Stats Card:**
    *   Greeting: "What's up, \[Username]!"
    *   Key Stats: Current Rank Tier (e.g., "Gold III"), Key PRs (e.g., 2k, 5k), equipped cosmetic rank badge.

2.  **"Quick Start" Actions Card:**
    *   Buttons: "Start Solo Row" (-> Train Tab, pre-fills "Just Row"), "Find a Race" (-> Race Tab).
    *   **UI:** Large, inviting Buttons with icons.

3.  **Upcoming Races/Events Card (Dynamic):**
    *   Horizontally scrollable list of registered or featured/popular races.
    *   Per race: Name, Type (Live/Async), Start Time/Window, Entry Fee.
    *   Tap navigates to `RaceDetailView` (within Race Tab context).
    *   **UI:** ScrollView, Card views, Text, Icons.

4.  **Recent Activity/Progress Card (Optional):**
    *   Summary of last solo workout (e.g., "Last Row: 5000m, 20:00, 1:45/500m avg.").
    *   Link to full workout history (Profile).
    *   **UI:** Text, display cards.

5.  **Featured Content/News Card (Optional):** App news, features, community highlights.
    *   **UI:** Image, Text, Link.

---

### 2.4. Train Tab (`SoloTrainingView` / `WorkoutView`)

**Goal:** Log solo PM5 rowing sessions, earn "Tickets," track performance.

**Main View (`SoloTrainingView`):**

1.  **Setup Workout Card:**
    *   Title: "Start a New Solo Row."
    *   Workout type options ("Just Row" [default], Single Distance, Single Time, Intervals: Distance, Intervals: Time). Future: Set Calories, Predefined Workouts.
        *   User inputs parameters (distance, time, splits, rest) via TextFields, Pickers, or Sliders.
    *   Button: "Start Rowing" (active if PM5 connected & parameters valid).
    *   **UI:** SegmentedControl/Picker for type, TextFields, Steppers, Sliders for input, Button.

2.  **PM5 Connection Prompt (Contextual):** If PM5 disconnected, prominent "Connect PM5 to Start Training" message/button.

3.  **Recent Solo Workouts List (Optional):** Brief list of recent workouts as expandable cards showing key stats. Tap to view full details.
    *   **UI:** List of expandable cards, Text.

**During Workout View (`WorkoutInProgressView` - Full Screen):**
*   **Trigger:** Tap "Start Rowing" with connected PM5.
*   **Layout:** Clear, large, real-time display of all key rowing metrics (from PM5 via CSAFE) without scrolling.
*   **Metrics:** Primary (Time, Distance, Pace, SPM, Power), Secondary (Avg Pace, Heart Rate, Calories), Progress indicators for goals.
    *   **UI:** Large Text views, Gauges/Progress Bars.
*   **Controls:**
    *   "End Workout" Button: Stops tracking *in Oarena only*. User is prompted to save current progress and reminded to manually end the workout on the PM5. Workout saved as 'completed' up to that point.
    *   **UI:** Buttons with clear icons.

**Post-Workout Summary View (`WorkoutSummaryView` - Card):**
*   **Trigger:** User ends and saves workout.
*   **Content:** Totals (Time, Distance), Averages (Pace, Power, SPM, HR), Calories, Max HR. "Tickets" Earned (with info icon explaining calculation: volume + intensity). Rank Points (RP) gained and resulting rank tier improvement. Optional performance charts (`SwiftUI Charts`).
*   **Buttons:** "Done" (returns to Train tab), "Save & View Details" (saves to history, navigates to `WorkoutDetailView` under Profile).
*   **UI:** Text, Icons, Button, `Charts`.

---

### 2.5. Race Tab (`RaceHubView`)

**Goal:** Central hub to find, join, create, and participate in races (Asynchronous & Real-time; Duels, Regattas, Tournaments).

**Main View (`RaceHubView`):**
*   Tabbed interface/SegmentedControl for sub-sections. Card-based UI for race listings.
*   **Sub-sections:**
    1.  **Featured/Live Races:** Prominent cards for ongoing/upcoming live races, special events, public races, or races with friends. Cards note average rank of participants.
    2.  **All Races (`RaceListingView`):** Filterable (Mode, Format, Entry Fee, Distance/Time, participant rank) & sortable (Start Time, Fee, Popularity) list of all races, prioritizing similar-ranked opponents.
    3.  **My Races (`MyRacesView`):** User's registered/in-progress races ("Upcoming," "In Progress"). Completed races are in Profile > Race History.
    4.  **Create Race (`ScheduleRaceView`):** Interface to set up user-defined races.

**1. Featured/Live Races View:** Curated list with larger cards, countdowns, participant counts.
    *   **UI:** `ScrollView`, custom `CardView`.

**2. All Races View (`RaceListingView`):**
    *   **Filters/Sorts:** `Picker`/custom filter sheet, `Menu`.
    *   **Race List:** `CardView` per race (Name, Mode, Format, Distance/Time, Ticket Fee, Participants, Start/Deadline). Tap card to open `RaceDetailView`. Ticket price clearly shown.
    *   **UI:** `List`/`ScrollView` of `CardView`s, Text, Icons.

**3. My Races View (`MyRacesView`):** Segmented ("Upcoming," "In Progress"). Lists races similar to `AllRacesView`. Tap card for `RaceDetailView`.

**4. Create Race View (`ScheduleRaceView` - Modal/Sheet):**
    *   **Form:** Race Name, Mode (`Picker`), Format (`Picker`), Max Participants (if Group), Workout Type/Value, Entry Fee (Tickets), Start Time/Deadline (Live - `DatePicker`), Race Window (Async - `DatePicker`), Optional Description.
    *   **Validation:** Logical inputs. **Cost Summary:** Displays how prizes are funded (typically participant fees) and any creator listing fee (if applicable).
    *   Button: "Schedule Race" (checks Ticket balance if fee applies).
    *   **UI:** `Form`, `TextField`, `Picker`, `DatePicker`, `Stepper`, `TextEditor`, `Button`.

**Race Detail View (`RaceDetailView` - Modal/Pushed):**
*   **Trigger:** Tapping a race card from any list.
*   **Content:** All race parameters, Participant List (Live races), Prize Structure, Rules.
*   **Actions (Contextual):** "Join Race (X Tickets)" (confirms Ticket deduction), "View Lobby" (Live, pre-start), "Start Race Now" (Async, in window), "Edit/Cancel Race" (if user-created, pre-deadline).
*   **UI:** `ScrollView`, `Text`, `List`, `Button`.

**Live Race View (`LiveRaceView`):**
*   **Trigger:** Joining a live race at start, or from "My Races."
*   **Pre-Race Lobby (Optional):** Countdown, participant list, future chat.
*   **During Race:** User's metrics (like `WorkoutInProgressView`). Real-time visualization of other racers' progress (e.g., virtual lanes, with user's lane always prominent/fixed). Rank/Position indicator.
    *   **UI:** Large `Text`, custom progress views.
*   **Post-Race:** Transitions to `RaceResultView`.

**Asynchronous Race View (`AsyncRaceView`):**
*   **Trigger:** Tap "Start Race Now" for an joined async race.
*   **Interface:** Same as `WorkoutInProgressView`. PM5 controls workout setup.
*   **Post-Attempt:** Shows user's result. Data submitted to backend for processing and reward distribution after race window closes. Navigates to `RaceResultView` (provisional ranking).

**Race Result View (`RaceResultView`):**
*   **Trigger:** Finishing a race, or viewing completed race from "My Races" (Profile).
*   **Content:** Race Name/Details. Final Standings/Leaderboard (available for async after race expiry). User's Rank, Metrics. "Tickets" Won / RP Gained/Lost, new rank tier.
*   **Buttons:** "Back to Race Hub," "View Full Leaderboard."
*   **UI:** `List` for standings, `Text`, `Icons`.

---

### 2.6. Rankings Tab (`LeaderboardView`)

**Goal:** Display leaderboards (global, regional, friends, groups) to motivate users.

**Main View (`LeaderboardView`):**
*   Tabbed interface/`SegmentedControl` for scopes: Global, Regional (user-set), Friends, Groups/Clubs.
*   **Rank Tiers Display:** Visual of rank tiers (Bronze to Elite) with icons/badges. User's current rank tier highlighted.
*   **Leaderboard List:** Users based on scope. Each row: Numerical Rank, Avatar, Username, Rank Tier (e.g., Gold III, derived from RP), and key PRs (e.g., 2k, 5k times). User's row always present and highlighted at the top.
    *   Tap user navigates to their public Profile (simplified).
    *   **UI:** `List`, `HStack` for rows, `Text`, `Image`.
*   **Filtering/Sorting:** Filter by Rank Tier. Sort by Numerical Rank (default), RP. Future: specific metrics.
    *   **UI:** `Menu`.
*   Search bar (`.searchable`) to find users.

---

### 2.7. Profile Tab (`ProfileView` & `SettingsView`)

**Goal:** View stats, history, manage account, configure settings.

**Main Profile View (`ProfileView` - ScrollView with Cards/Sections):**
*   **Sections:**
    1.  **User Summary Card:** Avatar (editable), Username, Current Rank Tier (visual badge), Total "Tickets" balance. Button: "Edit Profile" (-> `EditProfileView`).
    2.  **Key Performance Stats Card:** PBs (500m, 1k, 2k, 5k, 10k, 30min, 60min). Overall rowing summary (Total Distance/Time/Workouts).
    3.  **Race History Section:** Link to `RaceHistoryView`. Summary of last few races (cards like in Race Tab).
    4.  **Solo Workout History Section:** Link to `WorkoutLogView`. Summary of last few solo workouts (cards like in Train Tab).
    5.  **Achievements/Badges Card (Future):** Earned milestone badges.
    6.  **Settings & Store:** Button: "Settings" (-> `SettingsView`). Button: "Shop (Get More Tickets)" (-> `StoreView`).

**Edit Profile View (`EditProfileView` - Modal/Pushed):**
*   Fields: Change Avatar (`PhotosPicker`), Username (if allowed, with checks), Email (read-only/confirm change), Change Password. Button: "Save Changes."
*   **UI:** `Form`, `TextField`, `SecureField`, `Button`.

**Race History View (`RaceHistoryView` - Navigated from Profile):**
*   List of all completed races (cards). Shows Name, Date, User's Rank, Prize/RP change. Filters (Type, Date). Tap race for `RaceResultView`.
*   **UI:** `List`, `Text`, `Menu`.

**Solo Workout Log View (`WorkoutLogView` - Navigated from Profile):**
*   List of all completed solo workouts (cards). Shows Date, Type, Key Metrics, Tickets Earned. Tap workout for its `WorkoutSummaryView`.
*   **UI:** `List`, `Text`.

**Settings View (`SettingsView` - Navigated from Profile):**
*   `Form` with sections:
    *   **Account:** Logout, Delete Account (with confirmation).
    *   **PM5 Management:** Link to `PM5ConnectionView`. Option: auto-connect to last PM5.
    *   **Notifications:** Toggles for Race Reminders, New Friend Activity, Event Announcements.
    *   **Preferences:** Units (m/km/mi, lbs/kg - `Picker`/`SegmentedControl`). Theme (Light/Dark/System - `Picker`).
    *   **Support & Legal:** Links to Help/FAQ, Privacy Policy, Terms of Service (web views). App Version.
    *   **UI:** `Form`, `Section`, `Button`, `Toggle`, `Picker`, `NavigationLink`, `Text`.

---

### 2.8. Store (`StoreView`) - Purchasing Tickets

**Goal:** Allow users to purchase "Tickets" (virtual currency) via In-App Purchases (IAP).
**Access:** Not a main tab. Accessed via the **Ticket Counter** on the **Home** tab or the **"Shop" button** in the **Profile** tab.

**Main View (`StoreView`):**
*   **Layout:** Clean, card-based display of Ticket packages.
*   **Current Ticket Balance:** Prominently displayed at the top.
    *   **UI:** `Text` with Ticket icon.
*   **Ticket Packages (Cards):** Each shows Number of Tickets (e.g., "100 Tickets," "500 + 50 Bonus!"), Price (localized), "Buy" button. Optional "Best Value" badge.
    *   **UI:** `ScrollView` of `CardView`s, `Text`, `Button`, `Image`.
*   **Purchase Flow:**
    1.  Tap "Buy." Native iOS IAP sheet appears.
    2.  Successful: Confirmation message ("Purchase Successful! X Tickets added."). UI balance updates.
    3.  Failed/Cancelled: Appropriate message.
    *   **UI:** `Alert` or confirmation sheet.
*   **Legal:** "Restore Purchases" option. Link to terms.
    *   **UI:** `Button`, `Text`.

## 3. General UI Elements & Principles

Consistent application of these elements and principles is key.

### 3.1. Core UI Toolkit:
*   **SwiftUI:** Primary UI framework.
*   **Native iOS Components:** Prioritize standard controls for familiarity.
*   **SF Symbols:** Extensive use for icons. Custom icons match sporty, clean aesthetic.
*   **SwiftUI Charts:** For visual performance data.

### 3.2. Design Language & Feel:
*   **Fun & Sporty:** Warm colors (see `Oarena_Creative_Guidelines.md`), subtle shadows/gradients on cards/buttons, engaging language.
*   **Card-Based UI:** Organize content in clean, scannable cards with consistent padding, corner radius, and shadow.
*   **Intuitive & Streamlined:** Clear hierarchy, minimalism, predictable navigation, accessibility (adhering to Apple HIG).

### 3.3. Common UI Patterns:
*   **Loading States:** `ProgressView` or custom animations.
*   **Empty States:** Clear messages and CTAs (e.g., "No races joined. Find one!").
*   **Error Handling:** User-friendly `Alerts` or inline text explaining issues and solutions.
*   **Confirmations:** `Alerts`/action sheets for destructive actions or currency transactions.
*   **Forms:** `Form` for settings, creation views.
*   **Sheets & Modals:** For focused tasks (race creation, login, detail views).

### 3.4. Specific UI Element Usage:
*   **Sliders:** Selecting from continuous ranges (e.g., filter ranges).
*   **Steppers:** Incrementing/decrementing discrete values (e.g., race participants).
*   **Pickers & SegmentedControls:** Mutually exclusive options (e.g., workout type, race mode).
*   **Textfields:** Text/number input (e.g., username, search).
*   **Toggles:** On/off settings (e.g., notifications).
*   **ProgressViews/Bars:** Workout goal progress, loading.
*   **Gauges (SwiftUI):** Visually engaging real-time metrics display.

Adherence to these UX flows and UI principles will make Oarena functional, enjoyable, and motivating for rowers.
