**Project Context Document: Oarena - Overall Project Idea & Functionality**

**1. Project Name:**
    Oarena

**2. Core Concept:**
    Oarena is a **gamified competitive virtual rowing experience**. It connects directly to the **Concept2 PM5 ergometer (rowing machine monitor)** to facilitate real-time and asynchronous races, incorporating a virtual currency, reward system, and a comprehensive ranked leaderboard system.

**3. Primary Goal:**
    To create an engaging platform where Concept2 PM5 users can:
    *   Compete against each other in various race formats.
    *   Win virtual currency ("Tickets") and other prizes.
    *   Be motivated to train solo by earning "Tickets" and improving their rank.
    *   Purchase "Tickets" to participate more frequently.
    *   Climb a ranked leaderboard, achieving recognition and new tiers of competition.

**4. Key Functionalities:**

    **4.1. Concept2 PM5 Ergometer Integration:**
        *   **Connection:** The app must establish a stable connection (likely Bluetooth or ANT+) with the Concept2 PM5 monitor.
        *   **Data Acquisition:**
            *   During races: Real-time streaming of performance data (distance, pace, power, stroke rate, time, etc.).
            *   During solo training: Logging of workout data (distance, time, average pace, intensity metrics).
        *   **Control (Potential):** Ability to set up predefined race distances/times on the PM5 via the app (TBD if PM5 API allows this extent of control for races).

    **4.2. Competitive Racing System:**
        *   **Race Entry Requirement:** Users must spend "Tickets" (virtual currency) to participate in most races (some casual or rank-based modes might have different entry rules).
        *   **Race Modes:**
            *   **Live Races:** Users compete simultaneously, with real-time updates on positions and performance.
            *   **Asynchronous Races:** Users complete the same race course/distance independently within a set timeframe. Results are compiled and compared.
        *   **Race Formats:**
            *   **One-on-One Duels:** Direct head-to-head competition.
            *   **Group Races:** Multiple participants competing for a limited number of winning spots.
            *   **Tournament-Style Competitions:** Multi-round events where winners advance.
        *   **Race Scheduling:**
            *   Users can propose/schedule races or join existing ones.
            *   App-generated/scheduled events and tournaments.
        *   **Prizes:** Winners receive rewards, primarily "Tickets," but potentially also badges, cosmetic items, or Ranking Points (RP).

    **4.3. "Tickets" - Virtual Currency & Economy:**
        *   **Core Purpose:** The primary in-app currency used to enter specific races and competitions.
        *   **Acquisition Methods:**
            1.  **Winning Competitions:** Awarded to top performers.
            2.  **In-App Purchase (IAP):** Users can buy "Tickets" using real money.
            3.  **Solo Training Rewards:** Earned by logging qualifying solo workouts.
            4.  **(Potential) Rank Achievement Bonuses:** Awarded for reaching new rank tiers.
        *   **Scarcity & Value:** Designed to be a resource that encourages strategic participation, training, or purchase.

    **4.4. Solo Training & Rewards:**
        *   **Workout Logging:** Users connect their PM5 to the app to log their solo rowing sessions.
        *   **Ticket Earning Mechanism:** Users earn "Tickets" for completed solo workouts.
            *   **Proportional Rewards:** The number of Tickets earned will be algorithmically determined based on workout **volume** (e.g., total distance, duration) and **intensity** (e.g., average pace, power output, adherence to intensity zones if implemented).
        *   **Ranking Contribution:** Solo training performance (e.g., improving personal bests, consistent high-quality sessions) contributes to the user's overall ranking (see 4.5).
        *   **Incentive:** Motivates users to train regularly, fueling their ability to earn Tickets and improve their competitive standing.

    **4.5. Ranked Rowing & Social Leaderboards:**
        *   **Core Concept:** A persistent, tiered ranking system (e.g., Bronze, Silver, Gold, Platinum, Diamond, Elite) to measure and showcase user skill, dedication, and progress over time, inspired by systems like those in Clash Royale or League of Legends.
        *   **Ranking Points (RP) / Matchmaking Rating (MMR):**
            *   Users earn or lose RP/MMR based on:
                *   **Race Performance:** Winning races (especially against higher-ranked opponents or in designated ranked matches) grants RP/MMR. Losing results in RP/MMR loss. The amount gained/lost will depend on the rank difference between competitors.
                *   **Solo Training Impact:** While direct RP might not be awarded for solo training, consistent high-quality training, achieving personal bests, or completing specific training challenges could unlock rank progression milestones, qualify users for higher-tier ranked play, or contribute to a separate "effort" score that influences matchmaking or seasonal rewards.
        *   **Rank Tiers & Divisions:** A structured hierarchy of ranks, each potentially with sub-divisions (e.g., Gold III, Gold II, Gold I).
        *   **Progression & Demotion:**
            *   Users climb ranks by accumulating sufficient RP/MMR and potentially winning promotion series.
            *   Demotion can occur due to consistent losses or prolonged inactivity in ranked play.
            *   Seasonal resets might occur, requiring re-calibration or a soft reset of ranks.
        *   **Leaderboards:**
            *   Global, regional, and friend-specific leaderboards displaying current ranks and RP/MMR.
            *   Filterable by various metrics (e.g., specific distances, age group if implemented).
        *   **Social Integration:**
            *   User profiles prominently display current rank, season highs, race history, and key performance stats.
            *   Ability to view and compare ranks and stats with other users.
        *   **Motivation & Rewards:**
            *   Primary motivation is prestige, recognition, and the challenge of climbing.
            *   Exclusive cosmetic rewards (e.g., avatars, banner customizations, erg skins), badges, or titles tied to rank tiers or seasonal achievements.
            *   Access to higher-stakes or rank-exclusive tournaments.
        *   **Matchmaking:** The ranking system will be crucial for fair and competitive matchmaking in ranked race modes.

**5. Core User Flow / Engagement Loop:**
    1.  **Train Solo:** User logs solo workouts with PM5 via Oarena -> Earns "Tickets" & contributes to rank progression factors (e.g., improved PBs, consistency).
    2.  **(Optional) Purchase:** User buys "Tickets" with real money.
    3.  **Enter Race:** User spends "Tickets" (if required) to join a live, asynchronous, or ranked race.
    4.  **Compete:** User races using their PM5, with data streamed to Oarena.
    5.  **Outcome & Rewards:** User wins/loses -> Earns/loses RP/MMR (in ranked modes), potentially wins "Tickets" and other prizes.
    6.  **Rank Progression:** User's overall rank is updated based on race outcomes and potentially training milestones.
    7.  **Review & Strategize:** User reviews performance, leaderboard position, and plans next training or race.
    8.  Repeat cycle, aiming to improve, earn, and climb the ranks.

**6. Target User:**
    *   Owners of Concept2 PM5 rowing ergometers.
    *   Individuals seeking structured, competitive, and gamified rowing experiences.
    *   Users motivated by leaderboards, ranking systems, and achieving measurable progress.
    *   Rowers looking for a community and a way to make solo training more engaging and rewarding.
