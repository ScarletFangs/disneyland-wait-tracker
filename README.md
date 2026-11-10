# Disneyland Wait Tracker

An iOS app that shows every Disneyland wait time on one screen.

The official Disneyland app makes you open a map, pick a land, then pick a ride to see a single
wait number. I wanted the whole park in one scrollable list, so I built this.

## What it does

Six screens behind a bottom nav:

- A dashboard listing every attraction with its current wait or status
- A showtimes screen for live entertainment
- Favorites, stored in Firestore and updating live
- A profile screen handling login, logout, and upgrading a guest account
- A ride detail screen with Lightning Lane return times and price
- An auth screen with email and password login plus a guest option

## Working with the data

All live data comes from the [ThemeParks.wiki](https://themeparks.wiki/) API. Two things it
doesn't give you shaped most of the code.

It has no land field. Attractions come back as one flat list, so lands are joined client side
from `assets/data/ride_lands.json`, keyed on entity id. It also has no ride images, so the UI
uses colored land headers instead of photos.

Status is an enum rather than a boolean: `OPERATING`, `CLOSED`, `REFURBISHMENT`, and `DOWN`. I
only found `DOWN` by printing raw status strings after Pirates of the Caribbean rendered as
"Unknown". It wasn't in the reference I was working from. Closed and refurbished rides still
appear in the list, badged instead of carrying a wait number.

Showtimes come back in three shapes, not two. `Performance Time` entries have `endTime` equal to
`startTime` and read as a single moment. `Operating` and `Special Ticketed Event` entries are
ranges, like the 10 AM to 7 PM meet and greet at Royal Hall. The formatter dispatches on that
shape rather than on the type string, so a fourth type showing up can't break it.

Lightning Lane coverage is sparse and frequently null, so ride detail always renders a
"Not available" state rather than assuming a return time exists.

## Architecture

```
lib/
  models/     immutable data classes with null safe fromJson
  services/   ThemeParks API, Firebase Auth, Firestore
  screens/    one folder per screen
  widgets/    shared widgets
  theme/      AppColors, AppTextStyles, AppTheme
  utils/      validators and display helpers
```

A few decisions are worth explaining.

Services return error states instead of throwing. Any method taking user input returns
`Future<String?>`, where null means success and a string is a readable error sentence. Firebase
exception types never reach the screens. A switch maps codes like `email-already-in-use` and
`network-request-failed` to copy a visitor can actually act on.

Switches on enums have no `default` case. The analyzer then flags every consumer when a new
status is added, which is how I caught a missing branch after adding `DOWN`. Switches at the
boundary that parse open string sets keep their default, since unknown input is genuinely
possible there.

Guest accounts upgrade in place. Anonymous sign in creates a real Firebase uid, and linking an
email credential keeps that same uid, so a guest's saved favorites survive account creation. One
consequence: `authStateChanges()` never fires on a successful link, because the uid didn't
change. The profile screen rebuilds manually to flip from the guest view to the signed in view.

Concurrent link attempts used to kill the session. Two overlapping `linkWithCredential` calls
dropped the user back at the auth screen. Both forms now disable their buttons while a request
is in flight, which also stops double submits.

Client side validation is a pre-filter, not the gate. The email check is deliberately loose.
Firebase is the real validator, so this only exists to avoid a network round trip on input that
is obviously empty or malformed.

## Running it

Flutter, iOS only for now.

Firebase config is not in the repo. You'll need your own Firebase project with Authentication
(email/password and anonymous) and Cloud Firestore enabled, then:

```bash
flutterfire configure
```

That regenerates `lib/firebase_options.dart`, `ios/Runner/GoogleService-Info.plist`, and
`firebase.json`. After that:

```bash
flutter pub get
flutter run
```

## Status

All six screens work, and each has been walked through its offline, loading, and double tap
states. A visual redesign of every screen is finished and merged. A second design pass is being worked out in Figma before it goes into code.

Alerts are not built. The Firestore methods for storing a wait threshold exist, but no screen
uses them yet, and push notifications are out of scope for v1.

Disneyland Park only for now. California Adventure is the next thing I want to add, so the park
id lives as a named constant in `ThemeParksApi` instead of being inlined at the call site.
Adding the second park is mostly a matter of fetching both and grouping the dashboard by park.

Rough edges I know about and haven't fixed:

- The dashboard, showtimes, and favorites screens each fetch independently on launch, so the
  live endpoint gets hit more than once per start.
- Time formatting uses `.toLocal()`, which follows the device timezone instead of pinning
  America/Los_Angeles.
- Stale past dated showtime entries are greyed out but still listed.
- No state management package. Plain `setState` throughout, which holds up fine at this size.

## Notes

Data from ThemeParks.wiki.

`devlogs/` has a session by session record of the build, including how the bugs above got found
and the reasoning behind most of the decisions described here.
