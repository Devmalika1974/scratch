<!--- This file contains the architecture planned for each stage of the project. -->
# RoSpins: Spin & Scratch Game App

## Overview
RoSpins is a Flutter-based mobile game app where users can spin a wheel and use scratch cards to win virtual currency. The app only requires a username for identification (alphanumeric, 3-20 characters), with all user data stored locally using shared_preferences.

## Core Features (MVP)
1. Simple login with username validation
2. Spin wheel game (3 spins per day)
3. Scratch card game (1 free card per day)
4. Local user data persistence
5. AdMob integration for monetization
6. Roblox-inspired theme and design

## Technical Architecture

### Data Models
1. **User Model** - stores username, balance, spins left, scratch cards left, and timestamp for daily reset

### File Structure (11 files total)

```
lib/
├── main.dart              # App entry point, theme setup
├── models/
│   └── user_model.dart    # User data model
├── services/
│   ├── storage_service.dart  # Shared preferences implementation
│   └── ad_service.dart    # AdMob implementation
├── screens/
│   ├── login_screen.dart  # Username entry and validation
│   ├── home_screen.dart   # Main navigation hub
│   ├── spin_screen.dart   # Spin wheel game
│   └── scratch_screen.dart # Scratch card game
├── widgets/
│   ├── spin_wheel.dart    # Custom spin wheel widget
│   ├── scratch_card.dart  # Custom scratch card widget
│   └── custom_button.dart # Reusable styled button
```

## Implementation Plan

### Phase 1: Core Setup
1. Configure project with dependencies
2. Create user model and storage service
3. Implement login screen with username validation

### Phase 2: Game Features
1. Develop home screen with navigation
2. Create spin wheel component with animation
3. Implement scratch card feature with gesture detection
4. Add daily reset logic for game limits

### Phase 3: Monetization & Polish
1. Integrate AdMob services
2. Apply Roblox-inspired UI theme
3. Add animations and transitions
4. Implement data reset functionality

## Technical Details

### User Authentication
- Simple username validation (3-20 alphanumeric characters)
- No actual authentication, just local data association

### Local Storage
- Store user data using shared_preferences
- Associate saved data with username for persistence
- Track daily limits and reset at midnight

### Monetization
- App open ads on startup
- Native ads on home screen
- Interstitial ads after gameplay

### Game Mechanics
- Spin wheel: Animated wheel that stops on random rewards
- Scratch card: Gesture-based scratching to reveal prizes
- Daily limits: 3 spins and 1 scratch card per day

### Data Reset
- Option to clear data for a specific username
- Reset functionality available in the app settings

## Development Constraints
- Ensure responsive design for different screen sizes
- Optimize animations for performance
- Design with Roblox-inspired colors without copyright infringement

## Required Template Files
- No file upload, image upload, audio or video recording needed

## Final Steps
- Compile and test functionality
- Verify all features work as expected
- Confirm file count is within 10-12 file limit
-------------------------------------------------------------------

## RoSpins: Spin & Scratch Game App - Architecture Update for Withdrawal Feature

### Overview
This update introduces a Withdrawal feature, allowing users with a balance of 1500 points or more to transfer points to other existing users.

### Core Features (MVP) - Updated
1. Simple login with username validation
2. Spin wheel game (3 spins per day)
3. Scratch card game (1 free card per day)
4. Local user data persistence
5. AdMob integration for monetization
6. Roblox-inspired theme and design
7. **Withdrawal Page**: Users with >= 1500 points can send points to another valid username.

### Technical Architecture

#### Data Models
1. **User Model** - stores username, balance, spins left, scratch cards left, and timestamp for daily reset (No changes)

#### File Structure (12 files total) - Updated
```
lib/
├── main.dart              # App entry point, theme setup
├── models/
│   └── user_model.dart    # User data model
├── services/
│   ├── storage_service.dart  # Shared preferences implementation
│   └── ad_service.dart    # AdMob implementation
├── screens/
│   ├── login_screen.dart  # Username entry and validation
│   ├── home_screen.dart   # Main navigation hub
│   ├── spin_screen.dart   # Spin wheel game
│   ├── scratch_screen.dart # Scratch card game
│   └── withdrawal_screen.dart # NEW: Points withdrawal screen
├── widgets/
│   ├── spin_wheel.dart    # Custom spin wheel widget
│   ├── scratch_card.dart  # Custom scratch card widget
│   └── custom_button.dart # Reusable styled button
```

### Implementation Plan - Updated

#### Phase 1 & 2: (As before)

#### Phase 3: Monetization & Polish (As before)

#### Phase 4: Withdrawal Feature
1.  **Create `WithdrawalScreen` (`lib/screens/withdrawal_screen.dart`)**:
    *   UI:
        *   Input field for recipient's username.
        *   Input field for the amount to withdraw.
        *   "Send Points" button.
        *   Display current user balance and withdrawal threshold (1500 points).
    *   Logic:
        *   Accessible/functional only if the current user's balance is >= 1500 points.
        *   Recipient username validation:
            *   Must not be empty.
            *   Must be different from the sender's username.
            *   Must exist in storage (use `StorageService.userExists`).
        *   Amount validation:
            *   Must be a positive integer.
            *   Must be less than or equal to the sender's available balance (after ensuring sender has >= 1500).
        *   Transaction:
            *   Show a confirmation dialog before proceeding.
            *   Retrieve recipient's `UserModel` using `StorageService.getUser`.
            *   Debit points from sender: `sender.balance -= amount`.
            *   Credit points to recipient: `recipient.balance += amount`.
            *   Save both updated `UserModel` instances using `StorageService.saveUser`.
            *   Provide feedback (success/error messages) to the user.
            *   Update the user's state in `HomeScreen` via a callback.
2.  **Modify `HomeScreen` (`lib/screens/home_screen.dart`)**:
    *   Add a new "Withdraw" tab to the `TabBar`.
    *   Conditionally enable/disable the "Withdraw" tab or show a message if the user's balance is less than 1500 points.
    *   Pass the current `UserModel` and an update callback to `WithdrawalScreen`.
3.  **Update `StorageService` (`lib/services/storage_service.dart`)**:
    *   Ensure existing `saveUser`, `getUser`, and `userExists` methods are sufficient for the withdrawal logic. (They should be).

### Technical Details - Updated

#### Withdrawal Logic
-   Minimum balance of 1500 points required to access/use the withdrawal feature.
-   Points can only be transferred to existing, valid usernames.
-   The sender cannot transfer points to themselves.
-   All transactions update user data locally via `StorageService`.

### Development Constraints (As before)
### Required Template Files (As before)
### Final Steps (As before)

-------------------------------------------------------------------

## RoSpins: Spin & Scratch Game App - Architecture Update for Rewarded Page

### Overview
This update introduces a "Rewarded" page, offering users three ways to earn additional points: watching a rewarded video ad, playing an external game, and playing an external quiz.

### Core Features (MVP) - Updated
1.  Simple login with username validation
2.  Spin wheel game (3 spins per day)
3.  Scratch card game (1 free card per day)
4.  Local user data persistence
5.  AdMob integration for monetization (including rewarded video ads)
6.  Roblox-inspired theme and design
7.  Withdrawal Page: Users with >= 1500 points can send points to another valid username.
8.  **Rewarded Page**: Users can earn points by:
    *   Watching a rewarded video ad (50 points).
    *   Playing an external game (100 points, claimed manually).
    *   Playing an external quiz (100 points, claimed manually).

### Technical Architecture

#### Data Models
1.  **User Model** (`lib/models/user_model.dart`) - No changes to the structure. Balance will be updated.

#### File Structure (13 files total) - Updated
```
lib/
├── main.dart              # App entry point, theme setup
├── models/
│   └── user_model.dart    # User data model
├── services/
│   ├── storage_service.dart  # Shared preferences implementation
│   └── ad_service.dart    # AdMob implementation (updated for rewarded ads)
├── screens/
│   ├── login_screen.dart  # Username entry and validation
│   ├── home_screen.dart   # Main navigation hub (updated with Rewards tab)
│   ├── spin_screen.dart   # Spin wheel game
│   ├── scratch_screen.dart # Scratch card game
│   ├── withdrawal_screen.dart # Points withdrawal screen
│   └── reward_screen.dart   # NEW: Screen for earning rewards
├── widgets/
│   ├── spin_wheel.dart    # Custom spin wheel widget
│   ├── scratch_card.dart  # Custom scratch card widget
│   └── custom_button.dart # Reusable styled button
```

### Implementation Plan - Updated

#### Phase 1-3: (As before)
#### Phase 4: Withdrawal Feature (As before)

#### Phase 5: Rewarded Page Feature
1.  **Update `pubspec.yaml`**:
    *   Add `url_launcher` dependency for opening external game/quiz links.

2.  **Update `AdService` (`lib/services/ad_service.dart`)**:
    *   Add a new test ad unit ID for rewarded video: `ca-app-pub-3940256099942544/5354046379`.
    *   Implement `loadRewardedVideoAd(Function(RewardItem) onRewardEarned)` method.
        *   This method will load a `RewardedAd`.
        *   The callback `onRewardEarned` will be triggered by the ad SDK when the user successfully watches the ad, providing the reward details.
    *   Implement `showRewardedVideoAd()` method.
        *   This shows the loaded rewarded ad.
        *   Handle cases where the ad is not loaded.
    *   Update `dispose()` to also dispose of any loaded `RewardedAd`.

3.  **Create `RewardScreen` (`lib/screens/reward_screen.dart`)**:
    *   **UI**:
        *   Display three distinct sections or cards for each reward option:
            *   "Watch Ad & Earn": Button to watch ad, shows "50 Points".
            *   "Play Game & Earn": Button to open game link, shows "100 Points", and a "Claim Reward" button.
            *   "Play Quiz & Earn": Button to open quiz link, shows "100 Points", and a "Claim Reward" button.
        *   Use appropriate icons (e.g., `Icons.movie`, `Icons.games`, `Icons.quiz`).
        *   Show loading indicators when an ad is loading or a claim is being processed.
    *   **State Management**:
        *   Manage loading states for ad watching and reward claiming.
        *   Track if rewards for game/quiz have been claimed for the current session/day to prevent immediate re-claims (simple boolean flags for MVP).
    *   **Logic**:
        *   Receive `UserModel`, `Function(UserModel) onUserUpdated`, and `AdService` as parameters.
        *   **Watch Ad**:
            *   On button press, call `adService.loadRewardedVideoAd()` with a callback.
            *   The callback, when triggered by `AdService` after successful ad view, will:
                *   Update `_currentUser.balance += 50`.
                *   Call `widget.onUserUpdated(_currentUser)`.
                *   Show a success message.
            *   Then call `adService.showRewardedVideoAd()`.
        *   **Play Game/Quiz**:
            *   "Play Game/Quiz" button: Uses `url_launcher` to open the respective URLs (`https://10342.play.gamezop.com/` and `https://10378.play.quizzop.com/`).
            *   "Claim Reward" button (for Game/Quiz):
                *   Becomes active after the user presumably returns from the web view.
                *   On press:
                    *   Update `_currentUser.balance += 100`.
                    *   Call `widget.onUserUpdated(_currentUser)`.
                    *   Show a success message.
                    *   Disable the claim button for that specific task for a period or until next app session/day reset (for MVP, a simple disable after one claim per session might be sufficient).
    *   **Styling**: Ensure the page is engaging and fits the Roblox-inspired theme.

4.  **Modify `HomeScreen` (`lib/screens/home_screen.dart`)**:
    *   Add a new tab (e.g., "Rewards" with an icon like `Icons.star`) to the `TabBar`.
    *   In the `TabBarView`, add `RewardScreen`, passing the current `_user`, `_updateUser` callback, and `_adService` instance.

### Technical Details - Updated

#### Rewarded Ad Integration
-   Use `google_mobile_ads` package for rewarded video ads.
-   The ad unit ID `ca-app-pub-3940256099942544/5354046379` will be used.
-   Reward (50 points) is granted via the ad SDK's callback.

#### External Links & Manual Claim
-   Use `url_launcher` to open game and quiz URLs in an external browser or webview.
-   Since direct tracking of external activity is not feasible for MVP, rewards for playing games/quizzes will be based on the user manually pressing a "Claim Reward" button after they've been directed to the external site.
-   To prevent simple abuse, the "Claim Reward" button for games/quizzes could be disabled after one claim per app session or until the daily reset, though the latter adds complexity to `UserModel` and reset logic. For MVP, a simple one-time claim per screen visit or disabling the button after first claim might be sufficient. The `RewardScreen` will manage its own state for this.

### Development Constraints (As before)
### Required Template Files (As before)
### Final Steps (As before)

-------------------------------------------------------------------
## RoSpins: Spin & Scratch Game App - Architecture Update for Rewarded Page (Add Rate App Reward)

### Overview
This update adds a new option to the "Rewarded" page: allowing users to earn points by (supposedly) rating the app.

### Core Features (MVP) - Updated
1.  Simple login with username validation
2.  Spin wheel game (3 spins per day)
3.  Scratch card game (1 free card per day)
4.  Local user data persistence
5.  AdMob integration for monetization (including rewarded video ads)
6.  Roblox-inspired theme and design
7.  Withdrawal Page: Users with >= 1500 points can send points to another valid username.
8.  **Rewarded Page**: Users can earn points by:
    *   Watching a rewarded video ad (50 points).
    *   Playing an external game (100 points, claimed manually).
    *   Playing an external quiz (100 points, claimed manually).
    *   **NEW**: "Rating" the app (300 points, claimed manually after being directed to the app store).

### Technical Architecture

#### Data Models
1.  **User Model** (`lib/models/user_model.dart`) - No changes to the structure. Balance will be updated.

#### File Structure (13 files total) - No change in file count
```
lib/
├── main.dart              # App entry point, theme setup
├── models/
│   └── user_model.dart    # User data model
├── services/
│   ├── storage_service.dart  # Shared preferences implementation
│   └── ad_service.dart    # AdMob implementation (updated for rewarded ads)
├── screens/
│   ├── login_screen.dart  # Username entry and validation
│   ├── home_screen.dart   # Main navigation hub (updated with Rewards tab)
│   ├── spin_screen.dart   # Spin wheel game
│   ├── scratch_screen.dart # Scratch card game
│   ├── withdrawal_screen.dart # Points withdrawal screen
│   └── reward_screen.dart   # Screen for earning rewards (UPDATED)
├── widgets/
│   ├── spin_wheel.dart    # Custom spin wheel widget
│   ├── scratch_card.dart  # Custom scratch card widget
│   └── custom_button.dart # Reusable styled button
```

### Implementation Plan - Updated

#### Phase 1-4: (As before)

#### Phase 5: Rewarded Page Feature - Updated
1.  **`pubspec.yaml`**:
    *   Ensure `url_launcher` dependency is present (it should be from previous step).

2.  **`AdService` (`lib/services/ad_service.dart`)**: (No changes in this phase for this specific feature)

3.  **Update `RewardScreen` (`lib/screens/reward_screen.dart`)**:
    *   **UI**:
        *   Add a fourth distinct section or card for the "Rate App" reward option:
            *   "Rate App & Earn": Button to open app store page, shows "300 Points".
            *   A "Claim Reward" button.
        *   Use an appropriate icon (e.g., `Icons.star`).
    *   **State Management**:
        *   Add `_ratingRewardClaimed = false;` boolean flag.
    *   **Logic**:
        *   **Rate App**:
            *   "Rate App" button: Uses `url_launcher` to open the app's page on the respective app store (Google Play / Apple App Store).
                *   Implement placeholder URLs for store pages, with comments for developers to replace them with actual IDs.
                *   `android_store_url = 'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME'`
                *   `ios_store_url = 'https://apps.apple.com/app/idYOUR_APP_ID'`
        *   **Claim Rating Reward**:
            *   "Claim Reward" button (for Rating):
                *   Becomes active after the user presumably returns from the app store.
                *   On press:
                    *   Update `_currentUser.balance += 300`.
                    *   Call `widget.onUserUpdated(_currentUser)`.
                    *   Show a success message.
                    *   Set `_ratingRewardClaimed = true` to disable the claim button for the current session.
    *   **Styling**: Ensure the new card is consistent with others.

4.  **`HomeScreen` (`lib/screens/home_screen.dart`)**: (No changes in this phase for this specific feature, as RewardScreen is already integrated)

### Technical Details - Updated

#### App Rating Reward
-   The app will direct the user to the app store page using `url_launcher`.
-   It's not technically feasible to verify if the user actually rated the app or gave 5 stars. The reward is given based on manual claim.
-   Reward: 300 in-app points.
-   The "Claim Reward" button for rating will be a one-time claim per session/visit to the `RewardScreen`, similar to game/quiz rewards.
-   The UI text will say "Earn 300 Points" to be consistent with in-app currency.

### Development Constraints (As before)
### Required Template Files (As before)
### Final Steps (As before)

-------------------------------------------------------------------
## RoSpins: Spin & Scratch Game App - Architecture Update for Privacy Policy

### Overview
This update adds a "Privacy Policy" page accessible from the HomeScreen's menu.

### Core Features (MVP) - Updated
1.  Simple login with username validation
2.  Spin wheel game (3 spins per day)
3.  Scratch card game (1 free card per day)
4.  Local user data persistence
5.  AdMob integration for monetization
6.  Roblox-inspired theme and design
7.  Withdrawal Page: Users with >= 1500 points can send points to another valid username.
8.  Rewarded Page: Users can earn points through various activities.
9.  **NEW**: Privacy Policy page.

### Technical Architecture

#### Data Models
1.  **User Model** (`lib/models/user_model.dart`) - No changes.

#### File Structure (14 files total) - Updated
```
lib/
├── main.dart              # App entry point, theme setup
├── models/
│   └── user_model.dart    # User data model
├── services/
│   ├── storage_service.dart  # Shared preferences implementation
│   └── ad_service.dart    # AdMob implementation
├── screens/
│   ├── login_screen.dart  # Username entry and validation
│   ├── home_screen.dart   # Main navigation hub (UPDATED with Privacy Policy menu item)
│   ├── spin_screen.dart   # Spin wheel game
│   ├── scratch_screen.dart # Scratch card game
│   ├── withdrawal_screen.dart # Points withdrawal screen
│   ├── reward_screen.dart   # Screen for earning rewards
│   └── privacy_policy_screen.dart # NEW: Displays privacy policy
├── widgets/
│   ├── spin_wheel.dart    # Custom spin wheel widget
│   ├── scratch_card.dart  # Custom scratch card widget
│   └── custom_button.dart # Reusable styled button
```

### Implementation Plan - Updated

#### Phase 1-5: (As before)

#### Phase 6: Privacy Policy Feature
1.  **Update `pubspec.yaml`**:
    *   Add `flutter_markdown` dependency for rendering policy text.
2.  **Create `PrivacyPolicyScreen` (`lib/screens/privacy_policy_screen.dart`)**:
    *   **UI**:
        *   `Scaffold` with an `AppBar` titled "Privacy Policy".
        *   Body will use `MarkdownBody` from `flutter_markdown` to display the policy.
        *   The privacy policy text will be a long string constant within this file, formatted in Markdown.
    *   **Content**:
        *   Include standard sections: Introduction, Information We Collect (clarify it's local username and game data), How We Use Information, Data Storage and Security (local `shared_preferences`), Third-Party Services (AdMob, game/quiz links), Children's Privacy, Changes to This Policy, Contact Us (placeholder).
3.  **Modify `HomeScreen` (`lib/screens/home_screen.dart`)**:
    *   In the `PopupMenuButton` within the `AppBar`, add a new `PopupMenuItem` with the text "Privacy Policy".
    *   Update the `onSelected` callback of the `PopupMenuButton` to handle the new menu item.
    *   When "Privacy Policy" is selected, navigate to `PrivacyPolicyScreen` using `Navigator.push`.

### Technical Details - Updated

#### Privacy Policy Display
-   A new screen dedicated to showing the privacy policy.
-   Policy text will be embedded as a Markdown string and rendered using `flutter_markdown`.
-   Accessible via a menu option in the `HomeScreen`'s `AppBar`.

### Development Constraints (As before)
### Required Template Files (As before)
### Final Steps (As before)
