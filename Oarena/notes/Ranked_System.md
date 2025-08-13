# This file describes the rank system used in Oarena.

# Expanded Ranking System:
There are now 7 major ranks with 6 divisions each (except Elite), creating 37 total progression tiers from Iron VI to Elite.

**Major Ranks:**
- Iron (VI, V, IV, III, II, I) - 6 divisions
- Bronze (VI, V, IV, III, II, I) - 6 divisions  
- Silver (VI, V, IV, III, II, I) - 6 divisions
- Gold (VI, V, IV, III, II, I) - 6 divisions
- Platinum (VI, V, IV, III, II, I) - 6 divisions
- Diamond (VI, V, IV, III, II, I) - 6 divisions
- Elite - Single pinnacle tier

# Dominance Points (DP) System

## Core Principle: Performance-Gated Ranking
Your rank is **primarily determined by your verified erg times**. DP can only fine-tune your position within unlocked performance tiers.

## How the System Works:

### 1. Performance Gates (Primary Rank Determinant)
- **Time Verification Required**: You must hit the time requirements listed below to unlock each rank tier
- **Gate System**: Your maximum achievable rank is locked by your best verified times across 2k/5k distances
- **Examples**:
  - 8:30 2k time (OWM) → Maximum rank: Iron II (can't reach Iron I until you hit 8:12)
  - 6:30 2k time (OWM) → Can reach up to Gold III, but needs DP to climb within Iron→Gold range

### 2. DP System (Secondary Fine-Tuning)
**DP Range**: 0-1000 points per division (6000 points per major rank)

#### Training Consistency DP:
- **Daily Training**: +5-15 DP (diminishing returns after 7-day streaks)
- **Weekly Streak Bonus**: +25 DP (max once per week)
- **Training Cap**: Can only gain +200 DP per rank tier from training alone

#### Race Performance DP:
- **Race Wins**: +50-200 DP based on opponent rank differential
  - Beat higher rank: +150-200 DP
  - Beat same rank: +100-150 DP  
  - Beat lower rank: +50-100 DP
- **Race Losses**: -25-100 DP with rank differential protection
  - Lose to higher rank: -25-50 DP (protected losses)
  - Lose to same rank: -50-75 DP
  - Lose to lower rank: -75-100 DP
- **Performance Bonus**: +50 DP for setting new personal bests in races

### 3. Rank Progression Logic
```
If (best_verified_time >= next_rank_requirement) {
    Unlock next rank tier
    If (current_DP >= 800) {
        Auto-promote to newly unlocked tier
    }
} else {
    Cap progression at current performance tier
    DP can only move within unlocked tiers
}
```

### 4. User-Facing Explanation
**"How Dominance Points Work"**

**Performance Gates**: Your rank is earned by hitting time standards. Faster times unlock higher ranks.

**Dominance Points**: Fine-tune your position through:
- **Training**: +5-15 DP daily (max +200 per rank from training)
- **Race Wins**: +50-200 DP vs stronger opponents  
- **Race Losses**: -25-100 DP (smaller losses vs stronger opponents)

**Example**: An 8:30 2k time unlocks Iron II max. No amount of training alone can reach Bronze - you need a 7:51 2k time first.

**Time Distribution Philosophy:**
- Larger improvements between lower ranks (Iron/Bronze) for faster initial progression
- Smaller improvements between higher ranks (Platinum/Diamond) reflecting the difficulty of elite performance
- Total range preserved: Iron VI = old Bronze III, Elite = unchanged

**OWM 2k Step Sizes (seconds improvement to reach next division):**
*Iron Divisions:* 20s, 18s, 16s, 14s, 12s, 10s = 90s total
*Bronze Divisions:* 9s, 9s, 8s, 8s, 7s, 7s = 48s total  
*Silver Divisions:* 6s, 6s, 5s, 5s, 4s, 4s = 30s total
*Gold Divisions:* 3s, 3s, 3s, 3s, 2s, 2s = 16s total
*Platinum Divisions:* 2s, 2s, 2s, 2s, 1s, 1s = 10s total
*Diamond Divisions:* 1s, 1s, 1s, 1s, 1s, 1s = 6s total

**Total Improvement:** 90 + 48 + 30 + 16 + 10 + 6 = 200s (Iron VI 9:20.0 → Elite 6:00.0)

**OWM 5k Step Sizes (using 2k step × 3.2 scaling factor):**
*Iron Divisions:* 64s, 58s, 51s, 45s, 38s, 32s = 288s total
*Bronze Divisions:* 29s, 29s, 26s, 26s, 22s, 22s = 154s total
*Silver Divisions:* 19s, 19s, 16s, 16s, 13s, 13s = 96s total  
*Gold Divisions:* 10s, 10s, 10s, 10s, 6s, 6s = 52s total
*Platinum Divisions:* 6s, 6s, 6s, 6s, 3s, 3s = 30s total
*Diamond Divisions:* 3s, 3s, 3s, 3s, 3s, 3s = 18s total

**EXPANDED RANK TARGET TIMES**
*Times represent the minimum performance (or faster) required to achieve the listed rank.*

**1. Open Weight Men (OWM)**

| Rank         | Division | 2k Time (mm:ss.0) | 5k Time (mm:ss.0) |
|--------------|----------|-------------------|-------------------|
| **Iron**     | VI       | 9:20.0            | 26:38.0           |
|              | V        | 9:00.0            | 25:34.0           |
|              | IV       | 8:42.0            | 24:43.0           |
|              | III      | 8:26.0            | 23:58.0           |
|              | II       | 8:12.0            | 23:20.0           |
|              | I        | 8:00.0            | 22:48.0           |
| **Bronze**   | VI       | 7:51.0            | 22:19.0           |
|              | V        | 7:42.0            | 21:50.0           |
|              | IV       | 7:34.0            | 21:24.0           |
|              | III      | 7:26.0            | 20:58.0           |
|              | II       | 7:19.0            | 20:36.0           |
|              | I        | 7:12.0            | 20:14.0           |
| **Silver**   | VI       | 7:06.0            | 19:55.0           |
|              | V        | 7:00.0            | 19:36.0           |
|              | IV       | 6:55.0            | 19:20.0           |
|              | III      | 6:50.0            | 19:04.0           |
|              | II       | 6:46.0            | 18:51.0           |
|              | I        | 6:42.0            | 18:38.0           |
| **Gold**     | VI       | 6:39.0            | 18:28.0           |
|              | V        | 6:36.0            | 18:18.0           |
|              | IV       | 6:33.0            | 18:08.0           |
|              | III      | 6:30.0            | 17:58.0           |
|              | II       | 6:28.0            | 17:52.0           |
|              | I        | 6:26.0            | 17:46.0           |
| **Platinum** | VI       | 6:24.0            | 17:40.0           |
|              | V        | 6:22.0            | 17:34.0           |
|              | IV       | 6:20.0            | 17:28.0           |
|              | III      | 6:18.0            | 17:22.0           |
|              | II       | 6:17.0            | 17:19.0           |
|              | I        | 6:16.0            | 17:16.0           |
| **Diamond**  | VI       | 6:15.0            | 17:13.0           |
|              | V        | 6:14.0            | 17:10.0           |
|              | IV       | 6:13.0            | 17:07.0           |
|              | III      | 6:12.0            | 17:04.0           |
|              | II       | 6:11.0            | 17:01.0           |
|              | I        | 6:10.0            | 16:58.0           |
| **Elite**    | ---      | 6:00.0            | 16:32.0           |

**2. Open Weight Women (OWW)**
*Adjustments: OWM 2k + 45 seconds; OWM 5k + 2 minutes 15 seconds*

| Rank         | Division | 2k Time (mm:ss.0) | 5k Time (mm:ss.0) |
|--------------|----------|-------------------|-------------------|
| **Iron**     | VI       | 10:05.0           | 28:53.0           |
|              | V        | 9:45.0            | 27:49.0           |
|              | IV       | 9:27.0            | 26:58.0           |
|              | III      | 9:11.0            | 26:13.0           |
|              | II       | 8:57.0            | 25:35.0           |
|              | I        | 8:45.0            | 25:03.0           |
| **Bronze**   | VI       | 8:36.0            | 24:34.0           |
|              | V        | 8:27.0            | 24:05.0           |
|              | IV       | 8:19.0            | 23:39.0           |
|              | III      | 8:11.0            | 23:13.0           |
|              | II       | 8:04.0            | 22:51.0           |
|              | I        | 7:57.0            | 22:29.0           |
| **Silver**   | VI       | 7:51.0            | 22:10.0           |
|              | V        | 7:45.0            | 21:51.0           |
|              | IV       | 7:40.0            | 21:35.0           |
|              | III      | 7:35.0            | 21:19.0           |
|              | II       | 7:31.0            | 21:06.0           |
|              | I        | 7:27.0            | 20:53.0           |
| **Gold**     | VI       | 7:24.0            | 20:43.0           |
|              | V        | 7:21.0            | 20:33.0           |
|              | IV       | 7:18.0            | 20:23.0           |
|              | III      | 7:15.0            | 20:13.0           |
|              | II       | 7:13.0            | 20:07.0           |
|              | I        | 7:11.0            | 20:01.0           |
| **Platinum** | VI       | 7:09.0            | 19:55.0           |
|              | V        | 7:07.0            | 19:49.0           |
|              | IV       | 7:05.0            | 19:43.0           |
|              | III      | 7:03.0            | 19:37.0           |
|              | II       | 7:02.0            | 19:34.0           |
|              | I        | 7:01.0            | 19:31.0           |
| **Diamond**  | VI       | 7:00.0            | 19:28.0           |
|              | V        | 6:59.0            | 19:25.0           |
|              | IV       | 6:58.0            | 19:22.0           |
|              | III      | 6:57.0            | 19:19.0           |
|              | II       | 6:56.0            | 19:16.0           |
|              | I        | 6:55.0            | 19:13.0           |
| **Elite**    | ---      | 6:45.0            | 18:47.0           |

**3. Lightweight Men (LWM)**  
*Adjustments: OWM 2k + 15 seconds; OWM 5k + 45 seconds*

| Rank         | Division | 2k Time (mm:ss.0) | 5k Time (mm:ss.0) |
|--------------|----------|-------------------|-------------------|
| **Iron**     | VI       | 9:35.0            | 27:23.0           |
|              | V        | 9:15.0            | 26:19.0           |
|              | IV       | 8:57.0            | 25:28.0           |
|              | III      | 8:41.0            | 24:43.0           |
|              | II       | 8:27.0            | 24:05.0           |
|              | I        | 8:15.0            | 23:33.0           |
| **Bronze**   | VI       | 8:06.0            | 23:04.0           |
|              | V        | 7:57.0            | 22:35.0           |
|              | IV       | 7:49.0            | 22:09.0           |
|              | III      | 7:41.0            | 21:43.0           |
|              | II       | 7:34.0            | 21:21.0           |
|              | I        | 7:27.0            | 20:59.0           |
| **Silver**   | VI       | 7:21.0            | 20:40.0           |
|              | V        | 7:15.0            | 20:21.0           |
|              | IV       | 7:10.0            | 20:05.0           |
|              | III      | 7:05.0            | 19:49.0           |
|              | II       | 7:01.0            | 19:36.0           |
|              | I        | 6:57.0            | 19:23.0           |
| **Gold**     | VI       | 6:54.0            | 19:13.0           |
|              | V        | 6:51.0            | 19:03.0           |
|              | IV       | 6:48.0            | 18:53.0           |
|              | III      | 6:45.0            | 18:43.0           |
|              | II       | 6:43.0            | 18:37.0           |
|              | I        | 6:41.0            | 18:31.0           |
| **Platinum** | VI       | 6:39.0            | 18:25.0           |
|              | V        | 6:37.0            | 18:19.0           |
|              | IV       | 6:35.0            | 18:13.0           |
|              | III      | 6:33.0            | 18:07.0           |
|              | II       | 6:32.0            | 18:04.0           |
|              | I        | 6:31.0            | 18:01.0           |
| **Diamond**  | VI       | 6:30.0            | 17:58.0           |
|              | V        | 6:29.0            | 17:55.0           |
|              | IV       | 6:28.0            | 17:52.0           |
|              | III      | 6:27.0            | 17:49.0           |
|              | II       | 6:26.0            | 17:46.0           |
|              | I        | 6:25.0            | 17:43.0           |
| **Elite**    | ---      | 6:15.0            | 17:17.0           |

**4. Lightweight Women (LWW)**
*Adjustments: OWM 2k + 60 seconds; OWM 5k + 3 minutes*

| Rank         | Division | 2k Time (mm:ss.0) | 5k Time (mm:ss.0) |
|--------------|----------|-------------------|-------------------|
| **Iron**     | VI       | 10:20.0           | 29:38.0           |
|              | V        | 10:00.0           | 28:34.0           |
|              | IV       | 9:42.0            | 27:43.0           |
|              | III      | 9:26.0            | 26:58.0           |
|              | II       | 9:12.0            | 26:20.0           |
|              | I        | 9:00.0            | 25:48.0           |
| **Bronze**   | VI       | 8:51.0            | 25:19.0           |
|              | V        | 8:42.0            | 24:50.0           |
|              | IV       | 8:34.0            | 24:24.0           |
|              | III      | 8:26.0            | 23:58.0           |
|              | II       | 8:19.0            | 23:36.0           |
|              | I        | 8:12.0            | 23:14.0           |
| **Silver**   | VI       | 8:06.0            | 22:55.0           |
|              | V        | 8:00.0            | 22:36.0           |
|              | IV       | 7:55.0            | 22:20.0           |
|              | III      | 7:50.0            | 22:04.0           |
|              | II       | 7:46.0            | 21:51.0           |
|              | I        | 7:42.0            | 21:38.0           |
| **Gold**     | VI       | 7:39.0            | 21:28.0           |
|              | V        | 7:36.0            | 21:18.0           |
|              | IV       | 7:33.0            | 21:08.0           |
|              | III      | 7:30.0            | 20:58.0           |
|              | II       | 7:28.0            | 20:52.0           |
|              | I        | 7:26.0            | 20:46.0           |
| **Platinum** | VI       | 7:24.0            | 20:40.0           |
|              | V        | 7:22.0            | 20:34.0           |
|              | IV       | 7:20.0            | 20:28.0           |
|              | III      | 7:18.0            | 20:22.0           |
|              | II       | 7:17.0            | 20:19.0           |
|              | I        | 7:16.0            | 20:16.0           |
| **Diamond**  | VI       | 7:15.0            | 20:13.0           |
|              | V        | 7:14.0            | 20:10.0           |
|              | IV       | 7:13.0            | 20:07.0           |
|              | III      | 7:12.0            | 20:04.0           |
|              | II       | 7:11.0            | 20:01.0           |
|              | I        | 7:10.0            | 19:58.0           |
| **Elite**    | ---      | 7:00.0            | 19:32.0           |

This expanded system provides 37 total progression tiers, giving users much more frequent opportunities for advancement while maintaining the performance-gated structure where actual erg improvements unlock higher potential ranks.