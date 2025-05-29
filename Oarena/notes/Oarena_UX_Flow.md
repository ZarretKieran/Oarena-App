# Oarena UX Flow Document (Revised)

This document outlines the user experience (UX) flow for the Oarena application, detailing navigation, menus, UI elements, and user interactions. The goal is to create a streamlined, intuitive, fun, and engaging experience for Concept2 PM5 users.

## Style Guide
Consult `Oarena_Creative_Guidelines.md` in the @notes folder for stylistic guidelines.

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
*   **Interconnectedness:** Ensure that there is always a button to get from one screen back to the previous screen (a user should never get "stuck" on a screen e.g. the race setup). Utilize a "back" button with a chevron icon in the top left of screens for this.

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

0.  **Ticket Counter:** At the top right corner, small. Tapping navigates to `StoreView` (see 2.8) for ticket purchases.

1.  **Welcome & User Stats Card:**
    *   Greeting: "What's up, \[Username]!"
    *   Key Stats: Current Rank Tier (e.g., "Gold III"), Key PRs (e.g., 2k, 5k), equipped cosmetic rank badge.

2.  **"Quick Start" Actions Card:**
    *   Buttons: "Start Solo Row" (-> Train Tab, pre-fills "Just Row"), "Find a Race" (-> Race Tab).
    *   **UI:** Large, inviting Buttons with icons.

3.  **Featured Races Card (Dynamic):**
    *   **Implementation:** Horizontally scrollable list of featured races from Race tab for consistency.
    *   **Enhanced Timing Display:** Each race card shows three-line timing format:
        *   Timing label (color-coded: Live races use highlight color, Async races use accent color)
        *   Specific timing text (e.g., "Today 8:00 PM" or "Sunday 11:59 PM")
        *   Countdown display (e.g., "Starts in 3 hours" or "2 days remaining")
    *   **Rank Requirements:** Clear display of required rank with color-coded text matching rank tiers
    *   **Race Details:** Name, Type (Live/Async), Entry Fee, Difficulty level
    *   **Joined Race Indicators (NEW v1.7):** 
        *   Compact "JOINED" badge displayed on race preview cards for races user has already joined
        *   Visual distinction with muted background opacity (0.8) and enhanced background color
        *   Disabled tap interaction for joined races (prevents duplicate race detail views)
        *   Consistent joined race state synchronization with Race tab for seamless user experience
    *   **Tap Behavior:** Opens detailed `RaceDetailView` with comprehensive race information (only for non-joined races)
    *   **Data Consistency:** Uses exact same race objects as Race tab to ensure identical details
    *   **UI:** `ScrollView` with `RacePreviewCard` components, enhanced timing displays, rank indicators, joined badges.

4.  **Recent Workouts Card (Enhanced):**
    *   **Implementation:** Displays 4 most recent solo workouts as individual tappable cards.
    *   **Per Workout Card:** Workout type (e.g., "5000m Distance Row"), summary metrics (distance, time, avg pace), time ago, tickets earned, and rowing icon.
    *   **Tap Behavior:** Opens full `WorkoutSummaryView` (see 2.4) with detailed metrics and performance analysis.
    *   **"View All" Button:** Links to comprehensive workout history (`WorkoutHistoryView` in Profile).
    *   **UI:** `LazyVStack` of `WorkoutCard` components, each with icon, text summary, and ticket display.
    *   **Data Source:** `WorkoutData` model with sample workout data including various workout types.

5.  **Featured Content/News Card (Optional):** App news, features, community highlights.
    *   **UI:** Image, Text, Link.

---

### 2.4. Train Tab (`SoloTrainingView` / `WorkoutView`)

**Goal:** Log solo PM5 rowing sessions, earn "Tickets," track performance.

**Main View (`SoloTrainingView`):**

1.  **PM5 Connection Status Card:** Interactive card at top showing connection status (green/red indicator). Tappable to toggle connection state for demo purposes.

2.  **Setup Workout Card:**
    *   Title: "Start a New Solo Row."
    *   **Workout Type Selection:** Individual button grid layout (not SegmentedControl):
        *   **First Row:** "Just Row" [default], "Single Distance", "Single Time" 
        *   **Second Row (Centered):** "Intervals: Distance", "Intervals: Time"
        *   Each button shows title and subtitle, with selected state styling
        *   **Implementation:** `WorkoutTypeButton` components in `VStack` with `HStack` rows
        *   **State Management:** Uses shared `UserData.selectedWorkoutType` for cross-tab consistency
    *   **Dynamic Parameter Input:** Based on selected workout type:
        *   **Single Distance:** Distance in meters (`TextField`)
        *   **Single Time:** Time in minutes (`TextField`) 
        *   **Intervals Distance:** Distance, Rest time, Sets (`HStack` of `TextField`s)
        *   **Intervals Time:** Time, Rest time, Sets (`HStack` of `TextField`s)
    *   **Start Button:** "Start Rowing" (active if PM5 connected & parameters valid).
    *   **UI:** Individual button grid, `TextField`s with `RoundedBorderTextFieldStyle`, `Button`.

3.  **PM5 Connection Prompt (Contextual):** If PM5 disconnected, prominent warning card with icon, message "Connect PM5 to Start Training," and "Connect PM5" button.

4.  **Recent Solo Workouts Card:** Brief list of recent workouts showing workout name, metrics, date, and tickets earned. "View All" button links to full history. Tap workout rows for details.
    *   **UI:** `LazyVStack` of `WorkoutPreviewRow` components, expandable cards showing key stats.

**Ticket Counter:** Identical to Home tab - top-right navigation bar with ticket count and plus icon.

**During Workout View (`WorkoutInProgressView` - Full Screen):**
*   **Trigger:** Tap "Start Rowing" with connected PM5.
*   **Layout:** Clear, large, real-time display of all key rowing metrics (from PM5 via CSAFE) without scrolling.
*   **Metrics:** Primary (Time, Distance, Pace, SPM, Power), Secondary (Avg Pace, Heart Rate, Calories), Progress indicators for goals.
    *   **UI:** Large Text views, Gauges/Progress Bars.
*   **Controls:**
    *   "End Workout" Button: Stops tracking *in Oarena only*. User is prompted to save current progress and reminded to manually end the workout on the PM5. Workout saved as 'completed' up to that point.
    *   **UI:** Buttons with clear icons.

**Post-Workout Summary View (`WorkoutSummaryView` - Modal):**
*   **Trigger:** User ends and saves workout, or taps workout card from Home/Train/Profile.
*   **Navigation:** Full-screen modal with NavigationView, "Back" button for dismissal.
*   **Content Sections:**
    1.  **Workout Header Card:**
        *   Workout type and date
        *   Rowing icon
        *   Key totals: Total Time, Distance (side-by-side display)
        *   **UI:** CardView with title, subtitle, and key metrics grid
    
    2.  **Performance Metrics Card:**
        *   2x2 grid of metric cards: Average Pace, Average Power, Average SPM, Max Heart Rate
        *   Each metric has icon, label, and value
        *   **UI:** `LazyVGrid` with `MetricCard` components, icons from SF Symbols
    
    3.  **Workout Results Card:**
        *   Calories burned (with flame icon)
        *   Tickets earned (with ticket icon and "+X" display)
        *   Rank Points gained (with chart icon and "+X RP" display)
        *   **UI:** Side-by-side layout with divider, prominent value displays
    
    4.  **Information Card:**
        *   "How Rewards Are Calculated" explanation
        *   Details about ticket earning based on volume + intensity
        *   Rank Points explanation relative to current tier
        *   **UI:** Light accent background, info icon, explanatory text
*   **Buttons:** "Back" (dismisses modal)
*   **UI Implementation:** SwiftUI with CardView components, proper Oarena color scheme, SF Symbols icons

**Workout Data Model:**
*   **Structure:** `WorkoutData` with complete metrics (type, date, time, distance, pace, power, SPM, HR, calories, tickets, RP)
*   **Sample Data:** 5 realistic workout examples including distance rows, time rows, intervals, and just row sessions
*   **Summary Property:** Contextual summary text for card display (varies by workout type)

---

### 2.5. Race Tab (`RaceHubView`)

**Goal:** Central hub to find, join, create, and participate in races (Asynchronous & Real-time; Duels, Regattas, Tournaments).

**Main View (`RaceHubView`):**
*   **PM5 Connection Status Card:** Identical to Train tab - shows at top of view.
*   **Tab Selection:** `SegmentedPickerStyle` with four sections: "Featured", "All Races", "My Races", "Create"
*   **Content Display:** `TabView` with `PageTabViewStyle` (no index indicators) for smooth tab switching
*   **Ticket Counter:** Identical to Home/Train tabs - top-right navigation bar with ticket count and plus icon.

**Sub-sections Implementation:**

**1. Featured Races View (`FeaturedRacesView`):**
*   **Implementation:** Curated list of 5 featured race cards in vertical scroll
*   **Enhanced Race Cards:** Each card includes:
    *   Color-coded timing display (three-line format with countdown)
    *   Prominent rank requirement with color-coded rank text
    *   Entry fee display with ticket icons
    *   Difficulty badges and race type indicators
*   **Joined Race Indicators (NEW v1.7):** 
    *   "JOINED" badge displayed on races user has already joined
    *   Visual distinction with muted background opacity (0.8) and darker background color
    *   Disabled tap interaction for joined races (prevents duplicate race detail views)
    *   Muted tap instruction text color to indicate limited interaction
*   **UI:** `ScrollView` with `LazyVStack` of enhanced `FeaturedRaceCard` components

**2. All Races View (`AllRacesView`):**
*   **Enhanced Search Functionality (v1.9):** 
    *   Expanded search scope to include race titles, workout types, descriptions, AND race creators
    *   Real-time filtering with immediate results as user types for comprehensive race discovery
    *   Search bar with magnifying glass icon maintains existing UI while expanding functionality
*   **Advanced Filter System (v1.9):** 
    *   Filter button with slider icon opens comprehensive `RaceFiltersView` sheet
    *   **Active Filter Indicator:** Red dot appears on filter button when any filters are applied
    *   **7-Category Filter System:**
        1. **Race Type**: Filter by "Live Race", "Async Race", or "All"
        2. **Format**: Filter by "Duel", "Regatta", "Tournament", or "All" 
        3. **Status**: Filter by "Upcoming", "In Action", "Completed", or "All"
        4. **Rank Requirement**: Filter by specific rank tiers or "Open to All" races
        5. **Entry Fee Range**: Custom dual-thumb slider (0-200 tickets, 5-ticket increments)
        6. **Availability**: Toggle to show only joinable races (excludes already joined)
        7. **Sorting**: 6 options including Featured First, Entry Fee (Low/High), Prize Pool, Participants, Starting Soon
*   **Interactive Filter UI Experience (v1.9):**
    *   **Active Filters Display:** Removable chips below search bar showing individual filter labels
    *   **"Clear All" Button:** Quick filter reset option in active filters row
    *   **Results Count:** "X races found" display for user awareness of filtered results
    *   **Custom RangeSlider:** Professional dual-thumb interface for precise entry fee range selection
    *   **Filter Sheet:** Organized form-based interface with proper section grouping and navigation
*   **Enhanced Race List:** 30+ race cards with comprehensive information display:
    *   Timing information with deadlines/start times
    *   Rank requirements clearly visible in race information section
    *   Color-coded rank badges and timing labels
*   **Joined Race Indicators (NEW v1.7):** 
    *   "JOINED" badge prominently displayed on joined race cards
    *   Visual distinction with enhanced background color and reduced opacity
    *   Conditional tap interaction - joined races cannot be tapped to prevent redundant navigation
    *   Clear visual feedback showing which races have been joined across the global platform
*   **Combinatorial Filtering Logic (v1.9):** All filters work together allowing complex race discovery
*   **Smart Performance:** Lazy evaluation and efficient filtering optimized for 30+ race dataset
*   **UI:** `HStack` with search/filter controls, active filter chips, `ScrollView` with `LazyVStack` of enhanced `RaceListCard` components

**3. My Races View (`MyRacesView`):** 
*   **Section Picker:** `SegmentedPickerStyle` for "Upcoming" vs "In Progress"
*   **Enhanced Race Display:** Shows rank requirements for joined races to remind users of progression
*   **Conditional Display:** Different card lists based on selection with rank requirement information
*   **UI:** `Picker` with segmented style, conditional `ScrollView` with enhanced `MyRaceCard` components

**4. Create Race View (`CreateRaceView`):**
*   **Form Structure:** Comprehensive race creation form in scrollable card
*   **Fields:** Race Name (`TextField`), Mode (`Picker` - Duel/Regatta/Tournament), Format (`Picker` - Live/Async), Max Participants (`Stepper`), Workout Type (`Picker` - Distance/Time), Entry Fee (`Stepper`), Start Date (`DatePicker`), Description (`TextEditor`)
*   **UI:** `ScrollView` with `CardView` containing form elements

**Race Detail View (`RaceDetailView` - Modal):**
*   **Trigger:** Tapping race cards from any section
*   **Implementation:** Full-screen modal with comprehensive race information
*   **Content Cards:**
    1. **Race Header:** Name, mode, format, workout type, start time with "FEATURED" badge
    2. **Enhanced Timing Section:** 
        *   Larger timing display with color-coded labels
        *   Dedicated timing card for async deadline warnings
        *   Clear distinction between live start times and async submission deadlines
    3. **Rank Requirements & Eligibility:**
        *   Prominent "Minimum: [Rank] Rank" display with larger text
        *   Color-coded rank badges (Bronze/Silver/Gold/Plat/Elite)
        *   Enhanced eligibility messaging with clear progression guidance
        *   Dedicated red warning card for ineligible users with rank requirement details
    4. **Participants:** Progress bar showing current/max participants with explanation text
    5. **Prize Structure:** 1st/2nd/3rd place breakdown with ticket amounts and total pool
    6. **Description:** Race details and rules
*   **Join Functionality:** Entry fee display, join button with ticket validation, confirmation dialog
*   **Race Card Consistency:** Identical race objects ensure same details across Home and Race tabs
*   **UI:** `NavigationView` with `ScrollView`, multiple `CardView` sections, enhanced timing displays, rank indicators, eligibility warnings

**Race Filters View (`RaceFiltersView` - Modal Sheet - NEW v1.9, Enhanced v1.10):**
*   **Trigger:** Tapping filter button in All Races View with comprehensive filter options
*   **Implementation:** Professional card-based filter interface with 6 organized cards (upgraded from form-based to match Create Race styling)
*   **Navigation Structure:** Modal sheet with NavigationView, streamlined "Cancel" button navigation
*   **Card-Based Design (v1.10):**
    1. **Header Card:** Filter introduction with slider icon and descriptive subtitle explaining purpose
    2. **Race Type & Format Card:** Combined card with flag icon containing:
        *   Race Type: Segmented picker for "All", "Live Race", "Async Race" selection
        *   Race Format: Wheel picker for "All", "Duel", "Regatta", "Tournament" options
    3. **Status & Requirements Card:** Combined card with seal icon containing:
        *   Status: Segmented picker for "All", "Upcoming", "In Action", "Completed" states
        *   Rank Requirements: Wheel picker with rank progression options (All Ranks, Open Races Only, Bronze+, Silver+, Gold+, Plat+, Elite+)
    4. **Entry Fee Range Card:** Enhanced card with ticket icon containing:
        *   Visual min/max indicators with styled ticket badges
        *   Custom RangeSlider with dual-thumb interface and stepped values (5-ticket increments)
        *   Contextual help text explaining slider usage
        *   Range bounds: 0-200 tickets covering all race entry fees
    5. **Availability & Sorting Card:** Combined card with arrow icon containing:
        *   Availability Toggle: "Only show races I can join" with conditional feedback text
        *   Sort Options: Wheel picker with 6 intelligent sorting options (Featured First, Entry Fee Low/High, Prize Pool, Participants, Starting Soon)
    6. **Action Buttons Card:** Professional button styling with:
        *   Primary "Apply Filters" button with gradient background and shadow
        *   Secondary "Reset All Filters" button with highlight color styling
*   **Enhanced Visual Design (v1.10):**
    *   Color-coded SF Symbol icons for each card header (flag, seal, ticket, arrow icons)
    *   Professional typography hierarchy with bold headers and clear labels
    *   Contextual help text and conditional feedback for better user guidance
    *   Card-based architecture matching Create Race and race card styling
    *   Enhanced entry fee display with visual ticket badges showing current min/max values
*   **State Management:** All filter states bound to AllRacesView for real-time filtering application
*   **Custom Components:** Purpose-built RangeSlider with drag gestures, visual feedback, and improved presentation
*   **UI:** `NavigationView` with `ScrollView`, organized `CardView` sections, enhanced visual hierarchy, professional action buttons

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
*   **Implementation Status:** ✅ IMPLEMENTED - Full leaderboard functionality
*   **Tab Selection:** `SegmentedPickerStyle` for scopes: "Global", "Regional", "Friends", "Groups"
*   **Content Display:** `TabView` with `PageTabViewStyle` for scope switching
*   **Current User Highlight:** User's rank prominently displayed at top of each leaderboard

**Per Scope Implementation:**

**1. Global Leaderboard (`GlobalLeaderboardView`):**
*   **User Stats Summary:** Current user's rank, points, tier with avatar
*   **Leaderboard List:** 50 users with rank number, avatar, username, tier badge, points
*   **UI:** `ScrollView` with `LazyVStack` of user rank rows

**2. Regional Leaderboard (`RegionalLeaderboardView`):**
*   **Location Display:** Shows user's region (e.g., "North America")
*   **Similar Structure:** User stats + regional rankings list
*   **UI:** Identical to Global with regional data

**3. Friends Leaderboard (`FriendsLeaderboardView`):**
*   **Empty State:** "No friends added yet" with "Add Friends" button
*   **Future:** Friend rankings when friend system implemented
*   **UI:** Empty state message with call-to-action

**4. Groups Leaderboard (`GroupsLeaderboardView`):**
*   **Empty State:** "Join a group to compete" with "Find Groups" button  
*   **Future:** Group/club competitions when group system implemented
*   **UI:** Empty state message with call-to-action

**Rank Tier System:**
*   **Visual Badges:** Bronze, Silver, Gold, Platinum, Diamond, Elite tiers
*   **Color Coding:** Each tier has distinct colors (bronze to blue/purple for elite)
*   **Point Thresholds:** Defined point ranges for each tier progression

**Sample Data:**
*   **Realistic Users:** 50 sample users with varied usernames, realistic point distributions
*   **Current User:** Integrated into leaderboard at appropriate rank position
*   **Tier Distribution:** Balanced across all tiers for realistic competition feel

---

### 2.7. Profile Tab (`ProfileView` & `SettingsView`)

**Goal:** View stats, history, manage account, configure settings.

**Main Profile View (`ProfileView`):**
*   **Implementation Status:** ✅ IMPLEMENTED - Full profile functionality with card-based layout
*   **Structure:** `ScrollView` with multiple card sections

**Card Sections Implementation:**

**1. User Summary Card:**
*   **Content:** User avatar, username ("Zarret"), current rank tier ("Gold III"), ticket balance
*   **Edit Profile Button:** Opens `EditProfileView` (placeholder functionality)
*   **UI:** `CardView` with avatar, stats grid, and action button

**2. Personal Records Card:**
*   **Metrics:** 500m, 1k, 2k, 5k, 10k, 30min, 60min personal bests
*   **Display:** 2-column grid with metric names and times
*   **Sample Data:** Realistic rowing times for each distance/duration
*   **UI:** `LazyVGrid` with metric pairs

**3. Rowing Stats Card:**
*   **Totals:** Total distance rowed, total time, total workouts, lifetime tickets earned
*   **Progress Elements:** Visual progress indicators where relevant
*   **UI:** Grid layout with icons and values

**4. Workout History Section:**
*   **Recent Workouts:** Last 5 workouts displayed as summary cards
*   **"View Full History" Button:** Links to comprehensive `WorkoutHistoryView`
*   **Workout Cards:** Show type, date, key metrics, tickets earned
*   **UI:** `LazyVStack` of workout summary cards

**5. Race History Section:**
*   **Recent Races:** Last few completed races
*   **"View All Races" Button:** Links to `RaceHistoryView`
*   **Race Cards:** Show race name, placement, date, rewards earned
*   **UI:** `LazyVStack` of race result cards

**6. Achievements Section:**
*   **Implementation:** Placeholder cards for future achievement system
*   **Display:** Badge-style achievement cards with icons and descriptions
*   **UI:** Horizontal scroll of achievement badges

**7. Settings & Store Actions:**
*   **Settings Button:** Links to `SettingsView`
*   **Shop Button:** Links to `TicketStoreView` 
*   **UI:** Action buttons at bottom of profile

**Settings View (`SettingsView`):**
*   **Implementation Status:** ✅ IMPLEMENTED - Comprehensive settings
*   **Structure:** `Form` with organized sections

**Settings Sections:**

**1. Account Management:**
*   **Logout Button:** Confirmation dialog before logout
*   **Delete Account:** Warning dialog with account deletion
*   **UI:** Destructive action buttons with confirmations

**2. PM5 Connection:**
*   **Connection Settings:** Link to PM5 pairing/management
*   **Auto-connect Toggle:** Preference for automatic connection
*   **UI:** Navigation link and toggle controls

**3. Notifications:**
*   **Toggle Controls:** Race reminders, friend activity, announcements
*   **Implementation:** Individual `Toggle` controls for each notification type
*   **UI:** Standard iOS toggle switches

**4. Preferences:**
*   **Units:** Distance (meters/kilometers/miles), Weight (kg/lbs)
*   **Theme:** Light/Dark/System preference
*   **UI:** `Picker` controls for unit and theme selection

**5. Support & Legal:**
*   **Help Links:** FAQ, Support contact
*   **Legal Pages:** Privacy policy, Terms of service
*   **App Info:** Version number display
*   **UI:** Navigation links and informational text

**Modal Views:**

**Edit Profile View (`EditProfileView`):**
*   **Fields:** Avatar selection, username editing, email (read-only), password change
*   **Implementation:** Form-based editing with save/cancel actions
*   **UI:** `Form` with appropriate input controls

**Workout History View (`WorkoutHistoryView`):**
*   **Full List:** All completed workouts with filtering options
*   **Tap Action:** Opens `WorkoutSummaryView` for detailed metrics
*   **UI:** Searchable list with workout cards

**Race History View (`RaceHistoryView`):**
*   **Race Results:** All completed races with outcomes
*   **Filtering:** By race type, date range, results
*   **UI:** List of race result cards with filter controls

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

---

## 4. Implementation Status Summary

### ✅ **FULLY IMPLEMENTED**
*   **Home Tab:** Complete with all cards, navigation, and interactive elements
*   **Train Tab:** Full workout setup, type selection, and parameter input
*   **Race Tab:** Complete race hub with all sub-sections and detail view
*   **Rankings Tab:** Full leaderboard system with all scopes
*   **Profile Tab:** Complete profile and settings functionality
*   **Navigation:** Cross-tab navigation and shared state management
*   **Data Models:** UserData, WorkoutData with sample data
*   **Components:** CardView, ticket counters, PM5 status indicators

### 🚧 **PLACEHOLDER/FUTURE IMPLEMENTATION**
*   **User Authentication:** Login/Registration system (UI flows defined)
*   **PM5 Bluetooth Integration:** Real CSAFE commands and data (structure defined)
*   **Live Race Functionality:** Real-time racing with other users
*   **Workout In Progress:** Real-time PM5 data display during workouts
*   **Backend Integration:** Server communication for races, rankings
*   **Friend System:** Adding/managing friends for leaderboards
*   **Group/Club System:** Team-based competitions
*   **Achievement System:** Milestone badges and rewards
*   **In-App Purchases:** Real ticket purchasing via Apple IAP

### 📱 **UI/UX CONSISTENCY**
All implemented views follow the design principles outlined in this document:
*   Card-based UI with consistent styling
*   Oarena color scheme throughout
*   SF Symbols for icons
*   Native iOS SwiftUI components
*   Proper navigation and back button support
*   Ticket counter consistency across tabs
*   Interactive elements with proper feedback

## 5. Enhanced Data Models & User Experience (v1.3-1.4)

### 5.1. Advanced Race Timing System
**Implementation:** Comprehensive timing display distinguishing live races from async workouts
*   **Live Races:** Start times with countdown (e.g., "Today 8:00 PM", "Starts in 3 hours")
*   **Async Races:** Submission deadlines with deadline warnings (e.g., "Sunday 11:59 PM", "2 days remaining")
*   **Color Coding:** Live races use highlight color (urgent), async races use accent color (flexible)
*   **Display Format:** Three-line timing format on all race cards:
    1. Timing label ("Race Start" or "Submission Deadline")
    2. Specific date/time ("Today 8:00 PM")
    3. Countdown text ("Starts in 3 hours")

### 5.2. Flexible Rank Requirement System
**Implementation:** Optional rank requirements supporting both competitive and inclusive racing
*   **Optional Requirements:** `rankRequirement: String?` allows races without rank cutoffs
*   **Inclusive Racing:** "Community Open 10k" race with `nil` requirement welcomes all skill levels
*   **Dynamic UI Display:** Race cards automatically show "Open to: All Ranks" for inclusive races
*   **Positive Messaging:** "Open to everyone" status with accent color instead of warnings
*   **Smart Validation:** `UserData.meetsRankRequirement()` returns `true` for open races

### 5.3. Enhanced Rank Requirement Visibility
**Implementation:** Clear rank progression requirements across all race UI components
*   **Prominent Display:** "Minimum: [Rank] Rank" on race detail views with larger text
*   **Color-Coded Ranks:** Bronze (brown), Silver (gray), Gold (yellow), Plat (cyan), Elite (purple), Open (accent)
*   **Comprehensive Coverage:** Rank requirements shown on:
    *   `RacePreviewCard` (Home tab featured races)
    *   `FeaturedRaceCard` and `RaceListCard` (Race tab)
    *   `MyRaceCard` (joined races reminder)
    *   `RaceDetailView` (prominent requirement display)
*   **Conditional Warnings:** Red warning cards only appear for races with actual unmet rank requirements
*   **Adaptive Messaging:** Section titles change from "Rank Requirement" to "Eligibility" for open races

### 5.4. Complete Race Data Consistency
**Implementation:** Identical race information across all app locations
*   **Stable IDs:** Changed from `UUID()` to string-based IDs using race titles
*   **Shared Objects:** `sampleAllRaces` references exact same objects from `sampleFeaturedRaces`
*   **Full Discovery:** Home tab displays all 6 featured races with horizontal scrolling
*   **Identical Details:** Same race cards across tabs point to identical race information
*   **Consistent Experience:** Users see identical race details regardless of discovery location

### 5.5. Enhanced RaceData Model Structure
**Current Implementation:** Comprehensive race information with optional rank requirements
```swift
struct RaceData: Identifiable {
    let id: String // Stable string-based ID
    let title: String
    let raceType: String // "Live Race" or "Async Race"
    let rankRequirement: String? // Optional: "Bronze"/"Silver"/"Gold"/"Plat"/"Elite" or nil
    let specificStartDateTime: String // Live race start time
    let specificDeadlineDateTime: String // Async submission deadline
    
    // Computed properties for flexible display
    var timingLabel: String
    var timingDisplayText: String
    var countdownDisplayText: String
    var rankDisplayText: String // "Open to: Gold+" or "Open to: All Ranks"
    var rankColor: String // Color-coded by rank or accent for open races
}
```

### 5.6. Featured Race Portfolio
**Current Races:** 6 featured races covering all skill levels and formats
1. **Elite 2k Championship** - Elite rank required, Live race, High stakes competition
2. **Weekend Warriors 5k** - Silver rank required, Async race, Weekend flexibility
3. **Community Open 10k** - No rank requirement, Async race, Inclusive community event
4. **Beginner's Sprint Duel** - Bronze rank required, Live race, New racer introduction
5. **30-Minute Endurance Challenge** - Gold rank required, Async race, Distance accumulation
6. **Lightning Speed 500m** - Plat rank required, Live race, Sprint intensity

### 5.7. User Experience Improvements
**Enhanced Discoverability:** All featured races accessible from both Home and Race tabs
**Inclusive Design:** Mix of competitive rank-restricted and open community races
**Complete Information:** Users understand timing, eligibility, and requirements before joining
**Consistent Interface:** Identical race presentation across all UI components
**Positive Engagement:** Open races use encouraging messaging rather than restrictive warnings

This enhanced system ensures comprehensive race accessibility while maintaining competitive integrity through optional rank requirements.

### 5.8. Enhanced All Races Global Platform (v1.5)
**Implementation:** Comprehensive worldwide race discovery with professional-grade race ecosystem

**Expanded Race Portfolio:** 30+ races representing global rowing platform
*   **Elite/Professional Level:** World Championship Qualifier, International Open 6k, European Championship Heat, Pacific Rim 5k, Americas Cup Qualifier
*   **Competitive Ranks:** Masters Tournament 5k, Speed Demon 750m, Golden Hour 4k for Gold/Platinum level rowers
*   **Developing Rowers:** Silver Standard 3k, Lunch Break 1500m, Steady State Challenge for Silver level progression
*   **Beginner Friendly:** Newbie Friendly 2k, Coffee Break 800m, Family Fun Row for Bronze and new rowers
*   **Open Community:** Charity 10k for Health, Holiday Spirit 3k with inclusive participation
*   **Extreme Challenges:** Midnight Marathon (21k), 100k Ultra Challenge for ultimate endurance testing
*   **Time Trials:** Power Hour Challenge (60min), Quick 20 Minutes for distance accumulation races
*   **Regular Events:** Daily Distance Challenge, Tuesday Night Special, Weekend Warrior Revival for consistent participation

**Enhanced RaceListCard Styling:** Professional race card design matching featured races
*   **Comprehensive Information Display:** Race title, type/format, workout distance, timing details, rank requirements, participant counts, entry fees, prize pools, race creators
*   **Enhanced Timing System:** Three-line format with color-coded timing labels, specific dates/times, countdown displays
*   **Visual Consistency:** Light accent background, proper spacing, visual hierarchy matching featured race cards
*   **Interactive Elements:** Full tap area, race detail view integration, search highlighting

**Global Platform Scale:** Realistic worldwide competition ecosystem
*   **Participant Ranges:** 6-8 participants (intimate duels) to 500 participants (major international events)
*   **Entry Fee Structure:** 10 tickets (daily challenges) to 200 tickets (ultra endurance events)
*   **Prize Pool Scaling:** 60 tickets (quick sprints) to 8500 tickets (international competitions)
*   **Creator Diversity:** Official organizations, rowing clubs, coaches, community organizers, individual racers
*   **Geographic Representation:** International, regional, and local race creators from global rowing community

**Search & Discovery Enhancement:** Advanced race finding capabilities
*   **Multi-field Search:** Race titles, workout types, descriptions all searchable for comprehensive discovery
*   **Filter Integration:** Future filter system hookup ready for advanced sorting by rank, type, timing, entry fee
*   **Featured Integration:** All featured races included in global list while maintaining dedicated featured section
*   **Consistent Experience:** Identical detail views, join functionality, and information display across all race sources

This enhanced system creates a realistic global rowing competition platform where users can discover races at their skill level, from beginner-friendly community events to elite international championships, all with consistent professional presentation and full functionality.

## 6. Implementation Status Summary

## Race Terminology Clarification

**Race Formats** (How the race is structured):
- **Live Race**: Real-time synchronized racing where all participants race simultaneously at a specific time
- **Async Race**: Time-window racing where participants complete the race within a deadline period

**Race Status** (Current state of the race):
- **UPCOMING**: Race has not started yet (participants can still join)
- **IN ACTION**: Race is currently active (Live races are happening now, Async races are within submission window)  
- **COMPLETED**: Race has finished (results available)

**Visual Implementation**:
- Race cards display both format ("Live Race" or "Async Race") and status badge ("UPCOMING", "IN ACTION", "COMPLETED")
- Status badges use color coding: Upcoming (accent), In Action (highlight), Completed (secondary)
- This distinction prevents confusion between "Live Race" format and "Live" status