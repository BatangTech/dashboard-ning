frontend/lib/
├── component/
│   └── setting/                        # New UI components for settings page (modular & maintainable)
│
├── pages/
│   ├── dashboard_pages.dart           # Improved layout, connected to updated sidebar and header
│   ├── login_pages.dart               # Updated login UI & integrated with Firebase Auth
│   ├── profile_page.dart              # User info integration with Firebase + layout polish
│   └── settings_page.dart             # Redesigned settings with shared_preferences & clean sections
│
├── provider/
│   └── theme_provider.dart            # Theme management using Provider (Light/Dark mode support)
│
├── widgets/
│   └── dashboard/
│       ├── dashboard_header.dart      # Responsive header component, improved styling
│       └── dashboard_sidebar.dart     # Sidebar with active item highlight & navigation logic
│
└── main.dart                          # Integrated Provider, routing, and global theme setup
