frontend/lib/
├── component/
│   └── setting/                        # ปรับปรุง/สร้างคอมโพเนนต์ UI ของหน้า settings ใหม่ทั้งหมด
│
├── pages/
│   ├── dashboard_pages.dart           # ปรับ UI และเชื่อมต่อกับ sidebar/header ใหม่
│   ├── login_pages.dart               # ปรับ UI และการตรวจสอบผู้ใช้
│   ├── profile_page.dart              # เพิ่มข้อมูลจาก Firebase / ปรับ layout
│   └── settings_page.dart             # ยกเครื่องหน้า settings ด้วยระบบ shared_preferences และธีม
│
├── provider/
│   └── theme_provider.dart            # เพิ่ม dark/light mode ด้วย Provider
│
├── widgets/
│   └── dashboard/
│       ├── dashboard_header.dart      # ปรับปรุง layout + responsive
│       └── dashboard_sidebar.dart     # เพิ่มการจัดการเมนูและเชื่อมกับ navigation
│
└── main.dart                          # ผูก Provider + Routing เข้ากับระบบใหม่
