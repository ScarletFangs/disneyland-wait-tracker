# **System Requirements Specification**

[Link to Figma for design wireframe](https://www.figma.com/design/71wi6B6HKgyjPth4jPXmzl/School-Work?node-id=2003-5&t=9O0fkZ8Gcm7icnZE-0)  
[Changelog](#change-log)  
*Last Updated: Feb 18 (v1 build decisions amended 2026-06-05 — see banner below)*

---

> ⚠️ **v1 Reconciliation (2026-06-05) — read this first.** This SRS was written Feb 18, before the v1 build plan was finalized. Where the requirements below conflict with these notes, the notes win. Key deltas:
> - **Data source is the ThemeParks.wiki API**, not queue-times.com (so NFR-3.1's "match queue-times.com" now means ThemeParks.wiki). Status is an enum (OPERATING/CLOSED/REFURBISHMENT); the API has **no `land`** (joined from a curated `assets/data/ride_lands.json`) and **no ride images**.
> - **Lightning Lane:** *display* (return time / price / state) ships in v1 (FR-2.3, and FR-3.3 minus the booking button). LL **booking** (the "Book in official app" button) and LL **alerts** are **deferred**. LL coverage is sparse → always show a "Not available" state.
> - **Push notifications are deferred** out of v1 — so FR-4.2, FR-4.4, NFR-1.5, NFR-1.6, NFR-3.2 are *architected-for, not built*. Storing and managing alert thresholds (FR-4.1, FR-4.3) was planned for v1 but has not been built yet; see the implementation status below.
> - **Screens = 6** behind a **bottom navigation bar**: Wait Times · Showtimes · Favorites · Profile (tabs) + Ride Detail + Auth. The §3.1 list gains a **Showtimes** screen (live entertainment) not in the original spec.
> - Auth is **email/password + anonymous guest only** — **no Google Sign-In in v1** (supersedes FR-1.2's mention).

> 📋 **Implementation status (2026-11-09).** The requirement text below is the original February spec and was not edited. Against the code on `main`:
> - **Built:** FR-1.1 (guest mode — guests *can* save favorites, unlike the stated limitation), FR-1.2 (email/password only), FR-2.1, 2.2, 2.4 (non-operating rides are badged, not regrouped at the bottom), 2.10, 2.11, FR-3.1, 3.2, FR-3.3 without the booking button, FR-3.6, FR-5.1, 5.3, 5.4, FR-6.3 in part (view email, logout).
> - **Partly built:** FR-2.3 (Lightning Lane return time shows on the ride card and Ride Detail; no `$LL` badge), FR-2.9 (By Land / By Name only), FR-5.2 and FR-2.12 (a separate Favorites tab, not a dashboard filter chip).
> - **Not built:** FR-1.3, FR-2.5–2.8 (filters, search), FR-3.4 (static ride info), FR-3.5 and all of §3.2.4 (alerts — Firestore service methods exist, no UI), FR-6.1, 6.2, change password and delete account, NFR-1.4 (offline cache).
> - **Differs from the spec:** data is fetched straight from ThemeParks.wiki by the client, not read from Firestore (FR-2.1, 2.10, 3.2, NFR-1.2). Favorites are documents under `users/{uid}/favorites/{rideId}`, not an array. The favorite icon is a heart, not a star. A fourth status, `DOWN`, exists.
>
> The project README has the current status of the app.

---

# **1\. Introduction**

This document outlines the system requirements for a personal software development project. This SRS will serve as a foundational reference for the design, development, and testing of the system.

## **1.1 Purpose**

This System Requirements Specification (SRS) document describes the functionality and non-functional requirements for the Disneyland Wait Tracker mobile application. The application is designed to provide iOS users with instant access to wait times and Lightning Lane availability, eliminating the frustrating multi-screen navigation required by the official Disneyland app.

## **1.2 Scope**

**Product Name:** Disneyland Wait Tracker (working title)  
**Product Description:** A fast, lightweight companion app that solves two major pain points with the official Disneyland app:

* **Instant wait time access** \- open the app and immediately see all wait times (vs. 3-5 taps in official app)  
* **Lightning Lane visibility** \- quickly see which Lightning Lanes are currently available  
* **Smart alerts** \- get notified when ride drops below your desired wait time or when Lightning Lane become available

### **The Core Problem Being Solved:**

The official Disneyland app buries wait times behind multiple screens (Home \-\> Map \-\> Select Ride \-\> Scroll to wait time). Users have to repeat this process for every single ride they want to check. This app shows ALL wait times on one screen immediately upon opening.

**Target Users:** Disneyland visitors who:

* Frequently check wait times throughout the day  
* Are frustrated by the official app’s slow navigation  
* Want to quickly scan all wait times at a glance  
* Want to be notified instead of constantly checking  
* Need to see Lightning Lane availability quickly to make booking decision in the official app

### **What the system WILL do:**

* Display all attraction wait times on a single screen (instant access)  
* Show Lightning Lane availability status for all rides  
* Allow filtering by land/area for quick scanning  
* Send notifications when wait times drop below user thresholds  
* Send notifications when Lightning Lanes become available for select rides  
* Provide favorites/priority ride management  
* Show basic ride info (height requirements, status)

### **What the system will NOT do:**

* Book Lightning Lanes (users still use official Disneyland app for booking)  
* Purchase tickets or Genie+  
* Make dining reservations  
* Access PhotoPass  
* Show maps or navigation  
* Replace the official app entirely (this is a companion for wait times only)

# **2\. Overall Description**

## **2.1 Product Perspective**

Wait Tracker is a **companion application** that works alongside (not replacing) the official Disneyland app. The relationship is:

**Official Disneyland App (User still needs this):**

* Book Lightning Lane reservations  
* Purchase Genie+ or Individual Lightning Lanes  
* Buy tickets  
* Make dining reservations   
* View maps  
* Access PhotoPass photos

**Wait Tracker** **(this app):**

* **Primary use:** fast wait time checking  
* **Secondary use**: Lightning Lane availability overview  
* **Tertiary use**: smart notifications to reduce manual checking 

**The Value Proposition**: “Stop wasting time loading and navigating through menus. Open one app, see everything instantly.”

## **2.2 Product Functions** 

**Core Function \- Instant Wait Time Dashboard:**

* Single screen showing ALL attraction with current wait times  
* No navigation required \- everything visible immediately  
* Color-coded for quick visual scanning  
* Filters for quick refinement (by land, by ride type, favorites only)  
* Search bar for finding specific rides fast  
* Pull-to-refresh for manual updates

**Lightning Lane Quick View:**

* Visual indicator on each ride showing LL availability  
* Filter to show “LL Available Now” rides only  
* Quick reference before opening official app to book

**Smart Notifications** (reduce need to check):

* Set custom wait time thresholds per ride  
* Get alerted when rides drop below your threshold  
* Get alerted when Lightning Lanes become available  
* Reduces need to constantly open app

**Favorite/Priority Rides:**

* Star important rides for quick access  
* Filter to show only favorites  
* Set alerts only for rides you care about

**Basic Ride Information:**

* Height requirements  
* Ride duration  
* Operational status (Open, Down, Closed)  
* Ride type/category

## **2.3 User Characteristics**

### **Primary User Persona: “The Impatient Park-Goer”**

* Age: 20-45  
* In the park RIGHT NOW, walking around  
* Checks wait times 20-50 times per day  
* Frustrated with official app’s slow navigation  
* Just want to quickly decide “should we ride this now or come back later?”  
* Doesn’t want to dig through menus \- wants instant info

**Primary Use Cases:**

* **Walking past Space Mountain**: “Let me quickly check if the wait is reasonable” (2 seconds vs 30 seconds)  
* **Deciding next ride**: “Show me everything under 30 minutes” (filter instantly)  
* **Lightning Lane decision**: “Which LLs are available right now so I can book in the official app?”  
* **At lunch**: “Set alerts for my top 3 rides so I know when to head back to the park”  
* **Group decision**: “Everyone pull up the app \- what should we do next?” (instant consensus vs passing phone around)

### **Secondary User Persona**: “The Planner”

* Planning their day before arriving at the park  
* Sets up alerts in advance  
* Checks periodically 

## **2.3 Design Principles**

**Speed First:**

* App launch to data visible: \< 2 seconds  
* No splash screens, minimal animations  
* Aggressive caching for instant display  
* Data updates in background

**Simplicity:**

* One primary screen (dashboard)  
* Minimal navigation depth  
* Large, readable text for outdoor viewing  
* High contrast for bright sunlight readability

**Efficiency:**

* Everything accessible within 1-2 taps  
* Smart defaults (most common filters)  
* Reduce user decisions   
* No clutter, no  ads, no promotions

# **3\. Functional Requirements**

## **3.1 Screen Structure**

* **Screen 1:** authentication (optional \- can skip to guest mode)  
* **Screen 2:** wait times dashboard (Main screen \- 90 of usage here)  
* **Screen 3:** ride detail (tap any ride for more info)  
* **Screen 4:** my alerts (manage notifications)  
* **Screen 5:** settings/profile (notification preferences, account) 

## **3.2.1 Authentication & User Management**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-1.1: Guest Mode | System shall allow users to use app immediately without creating account | User opens app for first time | Skip authentication, provide full read-only access | Direct to dashboard | Cannot save favorites Cannot set alerts (no push notifications) | Users want instant access, not forced registration | **High** |
| FR-1.2: Optional Account Creation | System shall allow users to optionally create account to enable features | User taps “Sign Up” from settings or when trying to use alert features | Firebase Auth email/password or Google Sign-In | Account created, unlocks favorites and alerts | Forces an account creation step | Saves preferences across devices | Medium |
| FR-1.3: Account Benefits Prompt | When guest user tries to use alert/favorite feature, show benefits prompt | Guest taps favorite star or “Set Alert” | Show modal: “Sign up to save favorites and get notifications” | Option to sign up or continue as guest |  |  | Low |

## **3.2.2 Wait Times Dashboard (Primary Screen \- MOST IMPORTANT)**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-2.1: Instant All-Rides Display | System shall display ALL Disneyland attractions with current wait times on a single scrollable screen | App launch or tab switch to dashboard | Fetch from Firestore (cached data loads instantly) | Scrollable list of ride cards each showing: Ride name (large, bold) Wait time in minutes (extra large, color coded) Lightning Lane status badge (if available) Operational status (if down/closed) Favorite star icon (if logged in) | Load time requirement: \< 2 seconds from app launch | Main point of app optimized for quick scanning of information | **CRITICAL** |
| FR-2.2: Color-Coded Wait Times | Wait times shall use color coding for instant visual scanning  Color Logic: Green: 0-20min (short) Yellow: 21-45min (moderate) Red: 46+min (long) Grey: Closed/Temporarily Down |  |  |  | Must be readable, background color or text color on wait time number needs to change Readable in outdoor bright setting | Main point of app and very easy to read | **CRITICAL** |
| FR-2.3: Lightning Lane Availability Badge | Each ride shall clearly show if Lightning Lane is currently available Badge Options: LL \- 2:30pm (available and current bookable return time) $LL (paid LL ride) No badge if LL not available |  |  |  | API might be behind in updates or not have data for LL return times at all | Users can quickly scan which LLs they can book now | **High** |
| FR-2.4: Operational Status Indicators | Rides that are not operating shall be clearly marked Status Options: Temporarily Down (grey ride text) Operating (full opacity text) Closed (whole ride bar greyed out and grouped on the bottom) |  |  |  | Users should be able to easily tell what ride is open without crowding the UI | Users should easily tell what is open or closed | **High** |
| FR-2.5: Filter by Land/Area | User shall be able to quickly filter rides by park areas | Tap filter chips at top of screen | Filter list client-side (instant) | Filtered list, selected filter chip highlighted |  | User checking nearby rides instantly | **High** |
| FR-2.6: Filter by Lightning Lane Availability | User shall be able to filter to show only rides with Lightning Lane available | Tap “LL Available” filter chip | Show only rides that has Lightning Lane tag | Filtered list of bookable Lightning Lanes | Towards afternoon, certain Lightning Lanes will sell out, need to handle accordingly | Users can easily tell which rides they can book Lightning Lane for now | **High** |
| FR-2.7: Filter by Wait Time Threshold | User shall be able to filter to show only rides under certain wait time | Tap “Under 30 min” filter chip Options:  “Under 15min” “Under 30min” “Under 45min” Custom | Filter client side based on wait times known | Only rides meeting criteria |  | Users can decide accordingly for their plans | **Medium** |
| FR-2.8: Search for Specific Ride | User shall be able to search/filter by ride name | Type in search bar | Filter list as user types (real time) | Matching rides shown | Incorrect spelling New rides not updated in API | Users looking up a specific ride by search instead of other ways | **Medium** |
| FR-2.9: Sort Options | User shall be able to sort ride list | Tap sort button, select option Options: Shortest wait (ascending) Longest wait (descending) Alphabetical By land | Reorder list based on option selected | Re-sorted list | Slow down list generation based on sorting(?) | Easily see what is short to ride right now | **Medium** |
| FR-2.10: Pull to Refresh | User shall be able to manually trigger data refresh | Pull-down gesture on ride list | Force fetch latest data from Firestone | Refresh animation, updated wait times |  | “Data seems incorrect, let me force refresh” | **Medium** |
| FR-2.11: Last Updated Timestamp | Dashboard shall show when data was last updated |  | Compare current time to last updated timestamp | Display time since last update at top of screen |  | User knows if data is fresh or stale | **Medium** |
| FR-2.12: Favorites Quick Filter | Logged-in users can filter to show only favorited rides | Toggle “Favorites” filter chip | Filter rides in user’s favorites array | Only favorited rides shown | May not be in the order user wants to see | User sees information about their favorite rides easily | **Medium (requires login)** |

## **3.2.3 Ride Detail Screen**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-3.1: Tap to View Ride Details | Tapping any ride card shall open detail screen | Tap on ride card | Navigate to detail screen, pass ride data | Detail screen with comprehensive information |  | To display more information about the ride  | **High** |
| FR-3.2: Large Wait Time Display | Detail screen shall prominently display current wait time Design:  Large number at the top Color coded background |  | Firestore read the data from cache  | List last known wait time | May not be the most updated wait time | Important ride information | **High** |
| FR-3.3: Lightning Lane Details | Show detailed Lightning Lane information Display: Availability status  Soonest Return time window (if available) Price (for individual LL) Button: “Book in Disneyland App” (opens official app) | Tap on button | Exit out of application to take to official app | Exit out of application and take to official Disneyland app |  | Directly take users to app to book their Lightning Lane | **High** |
| FR-3.4: Basic Ride Information | Display static ride information Fields: Height requirement Ride type Location/Land |  | Load from firestore | Update fields from information from firestore |  | If user needs more information about these rides | **Medium** |
| FR-3.5: Quick Alert Setup | User can quickly set wait time alert from detail screen | Tap Bell Icon  | Create alert in Firestone | Confirmation, alert added to user’s alerts | App permissions disabled | Allows users to not constantly check their phone and be notified when a ride’s wait time is under their desired time | **High (requires login)** |
| FR-3.6: Add to Favorites | User can favorite ride from detail screen | Tap star icon | Add to user’s favorites array | Filled star icon, ride appears in favorites filter | User needs to be logged in | Allows users to favorite rides to see information about them easier | **Medium (requires login)** |

## **3.2.4 Alerts & Notifications System**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-4.1: Set Wait Time Threshold Alert | Logged-in users can set alerts to be notified when wait times drop | Select ride Tap bell icon Set threshold (minutes) | Store in Firestone /users/{uid}/alerts/{alertid} | Firestone will have a record of user wanting to be notified when condition is satisfied | User needs to be logged in App permissions disabled | Needed for ride notification system  | **CRITICAL** |
| FR-4.2: Push Notification \- Wait Time Alert | System sends push notification when wait time drops below threshold | Triggered when cloud function detects waitTime \< user’s threshold | Check alert hasn’t fired in last 30min (prevent spam) Check user’s quiet hours settings Send FCM notification Format: Title \- {ride} Alert Body \- “Wait time now {time}” Action \- Opens app to ride detail screen | Users will be alerted natively on their device when wait time reaches the threshold  | App permissions disabled Max 1 notification per ride per 30min to prevent spam | Allows users to not constantly check their phone and be notified when a ride’s wait time is under their desired time | **CRITICAL** |
| FR-4.3: My Alerts Management Screen | Users can view and manage all active alerts Display: Ride name Threshold Current status enable/disable toggle Delete button | Actions: Toggle alerts on/off Edit threshold Delete alert | Send information to firestone based on options toggled |  |  | Needed for users to tell app if they want alerts for certain rides or not | **HIGH** |
| FR-4.4: Alert Notification Preferences | Users can customize notification behavior | Settings: Enable/disable all notifications Edit Quiet hours (start time, end time) Maximum notification per hours Notifications | Cloud function checks these before sending |  |  |  | **Medium** |

## **3.2.5 Favorites/Priority Rides**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-5.1: Add Ride to Favorites | Users can star rides for quick access | Tap star icon on ride card or detail screen | Add rideID to /users/{uid}/favorites array | Filled star icon | User needs to be logged in | Users can pick specific rides they like | Medium (requires login) |
| FR-5.2: View Favorites Only | Dashboard can filter to show only favorites | Toggle “Favorites” filter chip | Filter to favorited rides | Reduced list showing only favorites with current wait times | User needs to be logged in  A ride needs to be favorited | “I only care about 5 specific rides, show me just those” | Medium (requires login) |
| FR-5.3: Remove From Favorites | Users can unfavorite rides | Tap filled star icon | Remove from favorites array | Unfilled star icon |  | Remove from favorites array if added | Medium (requires login) |
| FR-5.4: Favorites Persist Across Devices | Favorites sync Fia Firestore for logged-in users |  | Firestore handles sync automatically |  |  | User can check on phone and tablet | Low |

## **3.2.6 Settings & Preferences**

| ID | Description | Input | Processing | Output | Limitations | Rationale | Priority |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| FR-6.1: Notification Preferences | Users can customize notification behavior | Settings: Enable/disable all notifications Max notification per hour | Add to Firestore user document Default: enabled, max 5/hour |  | User needs to be logged in |  | **High** |
| FR-6.2: App Preferences | User can customize their app experience | Settings: Theme (light/dark/system) Default filter (All rides, Favorites) Default sort order | Storage: Shared Preferences (local) |  |  | Typical app settings people will change | Low |
| FR-6.3: Account Management | User can manage account Options: View email Change password Delete account Logout |  | Firebase auth methods |  | User needs to be logged in |  | Medium (requires login) |

# **4\. Non-Functional Requirements**

## **4.4.1 Performance Requirements**

* **NFR-1.1: App Launch Speed (CRITICAL)**  
  * **Requirement:** App shall launch and display cached wait times within 2 seconds  
  * **Measurement:** Time from icon tap to dashboard visible  
  * **Rationale:** Speed is the entire value proposition  
  * **Implementation:** aggressive local caching, minimal splash screen  
* **NFR-1.2: Data Refresh Speed**  
  * **Requirement:** Fresh data shall load from Firestore within 1 second  
  * **Measurement:** Time from app open to latest data displayed  
  * **Implementation:** Firestore real-time listeners, background sync  
* **NFR-1.3: Search/Filter Responsiveness**  
  * **Requirement:** Filtering and searching shall update UI within 100ms  
  * **Measurement:** Input to UI update latency  
  * **Implementation:** Client-side filtering, optimized list rendering  
* **NFR-1.4: Offline Graceful Degradation**  
  * **Requirement:** App shall display last cached data when offline  
  * **Display**: Showing cached data from “5 min ago” banner  
  * **Rationale:** better to show stale data than nothing  
* **NFR-1.5: API Polling Frequency**  
  * **Requirement**: Cloud function shall poll queue times every 5min  
  * **Rationale:** Balance between freshness and API limits  
* **NFR-1.6: Notification Latency**  
  * **Requirement:** Notifications shall be sent within   
  * **Measurement:** Time from Firestore update to FCM delivery  
  * **Implementation:** Cloud function triggers, efficient alert evaluation

## **4.4.2 Usability Requirements**

* **NFR-2.1: Outdoor Readability**  
  * **Requirement:** UI shall be readable in direct sunlight  
  * **Implementation:**   
    * High contrast colors  
    * Large text (min. 16pt for body, 24pt+ for wait times)  
    * Avoid low-contrast color combinations  
* **NFR-2.2: One Handed Operation**  
  * **Requirement:** All primary functions shall be accessible with thumb on standard iPhone  
  * **Implementation:** Bottom navigation, important buttons in reach zone  
* **NFR-2.3: Glanceable Design**  
  * **Requirement:** User shall be able to comprehend wait times within 3 seconds of looking at screen  
  * **Implementation:** Large text, color coding, minimal clutter  
* **NFR-2.4: Minimal Navigation Depth**  
  * **Requirement:** no feature shall require more than 2 taps to access from dashboard  
  * **Current Depth:**  
    * Dashboard: 0 taps (launch)  
    * Ride detail: 1 tap  
    * Set alerts: 2 taps (ride detail \-\> alert button)  
    * Manage Alerts: 1 tap (bottom navigation)

## **4.4.3 Reliability Requirements**

* **NFR-3.1: Data Accuracy**  
  * **Requirement:** Wait times shall match the **ThemeParks.wiki** API (changed from queue-times.com on 2026-06-05)  
  * **Validation:** Display timestamp of last update  
  * **Note:** App is only as accurate as the API source  
* **NFR-3.2:** **Notification Delivery Rate**  
  * **Requirement:** 95%+ of triggered notifications shall be delivered  
  * **Measurement:** FCM delivery reports  
  * **Fallback:** In-app notification badge for missed notifications  
* **NFR-3.3: Crash Rate**  
  * **Requirement:** App crash rate shall be \<0.5% of sessions  
  * **Measurement:** Firebase Crashlytics  
  * **Implementation:** Comprehensive error handling  
* **NFR-3.4: Alert Reliability**  
  * **Requirement:** Alerts shall not fire more than once per 30 minutes for same ride

## **4.4.4 Scalability Requirements**

* **NFR-4.1: Firestore Read/Write Limits**  
  * **Requirement:** Stay within Firebase free tier initially (50k reads/day, 20k writes/day)  
  * **Optimization:** Use real-time listeners instead of polling from client  
  * **Monitoring:** Firebase console usage metrics

*Note: the non-functional requirements stop here. The remaining items fell outside the scope of this project, which is a Flutter bootstrap submission and a personal-use app, not a public release.*

# **5\. Success Metrics & Launch Criteria**

## **5.1 \- Launch Criteria**

Must have:

* Guest mode (no login require)  
* All rides display with wait times  
* Lightning Lane availability visible  
* Filter by land  
* Search functionality  
* User authentication (for alerts)  
* Wait time threshold alerts  
* Lightning Lane availability alerts  
* Push notifications working  
* Favorites system  
* Settings (notification preferences)

Nice to have (probably implement after bootstrap completion):

* Wait time trend graphs  
* Historical insights  
* Advanced filtering (by wait time range)  
* Sort options  
* Notification history  
* Dark mode

# **Change Log** {#change-log}

| Date | Changes |
| :---- | :---- |
| 02/18/2026 | Finished the majority of the project description needed for planning. The remaining non-functional requirements were left out as out of scope. |
| 06/05/2026 | v1 reconciliation banner added (top). Switched data source queue-times.com → ThemeParks.wiki; Lightning Lane *display* moved into v1 (booking/alerts still deferred); added a Showtimes screen (6 screens total, bottom nav). |
| 11/09/2026 | Implementation status banner added (top), listing which requirements are built, partly built, or not built. Removed references to internal planning notes. |

