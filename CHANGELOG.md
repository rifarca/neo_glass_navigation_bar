## # Changelog

All notable changes to the **neo_glass_navigator** package will be documented in this file.

The format is based on \[Keep a Changelog]\(<https://keepachangelog.com/en/1.1.0/>),

and this project adheres to \[Semantic Versioning]\(<https://semver.org/spec/v2.0.0.html>).

\## \\\[0.1.5] - 2026-11-20

### ###Added

- change material_ui into replace of material 

\## \\\[0.1.4] - 2026-11-20

\### Added

\- **Direct Blur & Transparency Shortcuts:** Added `blurSigma` and `glassOpacity` properties directly on `NeoGlassNavigator` to adjust the base glass effect without instantiating a full `NeoGlassLayerConfig`.

\- **Desktop & Web Hover Support:**

&#x20; \- Integrated `MouseRegion` with `SystemMouseCursors.click` on every navigation item.

&#x20; \- Added `hoverLayer` (with `NeoGlassLayerConfig.iosHover` light/dark presets), `hoverScale`, and `hoverItemColor` for smooth interactive feedback.

\- **Flexible Positioning (**`NeoGlassPosition`\*\*):\*\*

&#x20; \- `NeoGlassPosition.bottom`: Floating bottom dock with outer margins and bottom `SafeArea`.

&#x20; \- `NeoGlassPosition.dockedBottom`: Full-width bottom bar with top rounded corners and automatic bottom inset padding, ready for `Scaffold.bottomNavigationBar`.

&#x20; \- `NeoGlassPosition.top`: Top floating navigation bar with top `SafeArea`.

&#x20; \- `NeoGlassPosition.custom`: Unconstrained positioning for custom placement inside any `Stack` or `Positioned` parent.

\- **Typography, Icon & Badge Tuning:**

&#x20; \- Added `labelStyle`, `selectedLabelStyle`, and `unselectedLabelStyle` for full font customization.

&#x20; \- Added `iconSize` and `iconLabelSpacing` controls.

&#x20; \- Added `badgeColor`, `badgeTextColor`, `badgeTextStyle`, and `badgeOffset` for granular badge styling.

\- **Documentation & Showcase:** Updated `README.md` with installation guides, basic and advanced usage examples, glass tuning tips, and a 4-screenshot showcase layout for Light and Dark modes.

\### Changed

\- Converted `NeoGlassNavigator` from a `StatelessWidget` to a `StatefulWidget` to manage hover state transitions smoothly.

\- Updated `NeoGlassLayerConfig.iosLightBase`, `iosDarkBase`, and `iosActivePill` factory constructors to accept optional `opacity` and `blur` parameters.

\---

\## \\\[0.1.0] - 2026-11-20

\### Added

\- Initial release of `NeoGlassNavigator` built on a multi-layer `Stack` architecture (`NeoGlassSurface`, `NeoGlassLayerConfig`, and `NeoGlassNavItem`).

\- Multi-layer iOS Liquid Glass rendering:

&#x20; 1\. Ambient drop shadow layer.

&#x20; 2\. Base `ClipRRect` + `BackdropFilter` blurred glass surface.

&#x20; 3\. Internal depth gradient layer (`depthLayer`).

&#x20; 4\. Top specular light reflection highlight.

&#x20; 5\. Animated sliding active pill (`activePillLayer`).

&#x20; 6\. Interactive icon, label, and optional badge layer with haptic feedback (`HapticFeedback.selectionClick`).

\- Automatic Light and Dark theme detection (`Theme.of(context).brightness`).

\- Example application demonstrating `NeoGlassNavigator` floating over `HomeTab` inside a background `Stack`.

\- Initial widget test suite verifying item rendering and tab selection callbacks.
