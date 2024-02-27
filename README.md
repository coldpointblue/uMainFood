# uMainFood

https://github.com/coldpointblue/uMainFood

Fun project, interesting little details tricky to get “just right”, but I think the UI, UX works well-enough to show the prototype. Main focus for me was UX.

Code is not perfect, it’s also not as modularized as I want, not optimized, but it’s OK to show that I know what I’m doing and am always learning new techniques.

**Please use iPhone 15 Pro in Simulator to review UI,** smaller screens don’t yet scale.

Project was made for modern iOS with Swift 5.9, SwiftUI and Combine. All code is Apple standard code, no external libraries.

UI works as close to the Design photo details that I noticed, like edges and shadows, separators, etc.

---

## Development Insights

...I developed this with Xcode using iPhone 15 Pro in Simulator, big screen to ensure I could see little details of the design working OK. But smaller screens don’t yet scale ratio from that 1:1 to their own screen height in Landscape or Width in Portrait mode.

---

## Extra UX details I liked & included:

- Scaling Filter buttons at top bar when tapped
- withAnimation Filters in UI for smooth List changes
- Landscape mode works in both List and Detail
- “Tap to Start Over” button to reload-data appears automatically because sometimes Refresh causes UI to glitch and List appears empty
- Error notifications when some problems arise

---

## Programming code with interesting details…

- API.Model.etc namespace for easy maintenance & changes
- Multi-threading with code for UI updates on main thread using `@MainActor` and `DispatchQueue.main.async` where suitable
- Publishers and Subscribers in Combine chains for dynamic UX
- Cache for images, for refreshing locally, fetching only when needed
- Custom error handling
- Included Localization
- Use Assets for Colors
- `@StateObject`, `@ObservedObject` for ObservableObject, Singletons + other mechanisms
- Network Service with generic data fetching and custom error mapping

---

## Modularity / better code I didn’t do because I was in a hurry…

I know how to do them and would, with more time, instead of being in a rush:
- Protocols with which I can simplify the error handling & data fetching
- Modularized `@ViewBuilder` views when appropriate
- Efficiency and extracting a few redundant actions for re-use in different places
- Unit Tests for business logic + to validate UI behavior for stability,reliability & simplifying future development
- Lots of other little details I know matter in the long-run for maintenance & testing
- Refactor and separate some code into several smaller files, enhancing single responsibility + easier maintenance

---

## A few next steps to think of…

### UI:
- Does not respond to Dark yet, need contrasting colors
- Sort the order of Restaurants alphabetically, or by rating, or wait-time, for example
- Need to scale for smaller screens 1:1 in iPhone 15 Pro, to smaller scale on iPhone SE
- Revise code to modularize within files and separate into smaller pieces when needed
- Revise code to ensure proper fileprivate, private, etc.

### Flaws and Hardest parts:

- Catching capital letter UUIDs failing on server, fixed by changing to lowercase before call.
  <simplest solution, waaaay too much time to figure out>

- “nw_connection_copy_connected_local_endpoint_block_invoke [C1] Connection has no local endpoint” … Haven’t figured out how to catch that networking problem so sometimes I have less filters in UI than I request (4 or 3 instead of 5). It appears it’s some low-level networking problem and does not trigger an Error in the app that my code can catch, at the moment.

- In addition, those errors sometimes appear but I have 5 filters in the UI and errors appear in the console anyway although all data is fetched OK. ¿? … No idea how to fix yet.

...Anyhow, again, fun project. I hope this prototype is good enough for you.

---

## P.S.
**IMPORTANT things I had no time to do just yet but I think are crucial…** Read the entire code in the project once again… Make sure that you:

- Have no force-unwraps anywhere
- No race-conditions
- Namespace usage is uniform and well-structured
- UI works well
- Threading logic uses a consistent pattern
- ViewModel is handled as `MainActor`
- Combine observers calls receive on Main
- `DispatchQueue.main.async` is used to update ViewModel values on Main
- Use `@Published` on observed data consistently, automatic, with no manual exceptions

---

Created by Hugo S. Diaz February 2024  
This project is Copyright © 2024 Hugo S. Diaz. All rights reserved.
