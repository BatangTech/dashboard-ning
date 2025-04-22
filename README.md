frontend/lib/
│
├── component/
│   └── setting/                 # 🔧 UI Components for Settings (modular & reusable)
│
├── pages/
│   ├── dashboard_pages.dart     # 📊 Main Dashboard UI + layout improvements
│   ├── login_pages.dart         # 🔐 Firebase Auth integrated login page
│   ├── profile_page.dart        # 👤 User profile + editable details
│   └── settings_page.dart       # ⚙️ Redesigned Settings UI with SharedPreferences
│
├── provider/
│   └── theme_provider.dart      # 🎨 Theme Provider (Light/Dark Mode support)
│
├── widgets/
│   └── dashboard/
│       ├── dashboard_header.dart   # 🧭 Top bar for dashboard navigation
│       └── dashboard_sidebar.dart  # 📚 Sidebar with routing & selection states
│
└── main.dart                    # 🚀 App entry point + routes + theme setup
