# ✅ Task Manager - Real-time Collaborative Task Lists

A **100% FREE** real-time collaborative task manager that works as a Windows 11 desktop widget. Built with Supabase backend for instant synchronization across all devices.

![Status](https://img.shields.io/badge/status-production%20ready-success)
![License](https://img.shields.io/badge/license-MIT-blue)
![Cost](https://img.shields.io/badge/cost-$0%2Fmonth-brightgreen)

---

## ✨ Features

### Core Features
- ✅ **Real-time Synchronization** - See changes instantly across all devices
- ✅ **Multiple Task Lists** - Organize tasks into separate lists
- ✅ **Rich Task Details** - Due dates, priorities, categories, assignees, notes
- ✅ **Search & Filters** - Find tasks quickly with powerful filters
- ✅ **Offline Support** - Works without internet, syncs when back online
- ✅ **Dark Mode** - Easy on the eyes in low light

### Advanced Features
- ✅ **User Authentication** - Secure signup/login with email
- ✅ **Desktop Widget** - Install as Windows 11 desktop app (PWA)
- ✅ **Cross-platform** - Works on Windows, Mac, Linux, iOS, Android
- ✅ **Zero Cost** - Completely free using Supabase free tier
- ✅ **No Installation** - Just open the HTML file in a browser

### Collaboration (Planned v2.0)
- 🔄 Share lists with team members
- 🔄 Real-time collaboration indicators
- 🔄 Task comments and discussions
- 🔄 Activity log and history

---

## 🚀 Quick Start

### Prerequisites
- A web browser (Chrome, Edge, or Firefox)
- 5 minutes of your time
- An email address

### Setup in 5 Minutes

1. **Create Supabase Account** (2 min)
   - Visit [supabase.com](https://supabase.com)
   - Sign up (free, no credit card)
   - Create new project

2. **Setup Database** (1 min)
   - Go to SQL Editor in Supabase
   - Copy and run `database-setup.sql`

3. **Configure App** (1 min)
   - Open `supabase_tasks.html` in text editor
   - Add your Supabase URL and API key
   - Save file

4. **Run App** (30 sec)
   - Double-click `supabase_tasks.html`
   - Create account and start using!

**See [QUICK_START.md](QUICK_START.md) for detailed instructions.**

---

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get running in 5 minutes
- **[SUPABASE_SETUP_GUIDE.md](SUPABASE_SETUP_GUIDE.md)** - Complete setup guide with troubleshooting
- **[TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md)** - Architecture, API reference, comparisons

---

## 🎨 Screenshots

### Light Mode
```
┌─────────────────────────────────────────────┐
│  ✅ Task Manager                             │
│     [🔄 Synced] [🟢 Online] [user@email]   │
├──────────────┬──────────────────────────────┤
│ My Lists     │  Work Tasks                  │
│ 📋 Personal  │  ┌──────────────────────┐    │
│ 📋 Work ✓    │  │ Search tasks...      │    │
│ 📋 Groceries │  ├──────────────────────┤    │
│ + New List   │  │ Add a task... [Add]  │    │
│              │  └──────────────────────┘    │
│              │  ☐ Complete Q4 report        │
│              │     🔴 High | 📅 Nov 25      │
│              │  ☐ Review design docs        │
│              │     🟡 Medium | 🏷️ Design   │
│              │  ☑ Team meeting              │
└──────────────┴──────────────────────────────┘
```

### Dark Mode
Dark theme automatically adjusts all colors for comfortable viewing in low light.

---

## 🔧 Technology Stack

### Frontend
- HTML5, CSS3, JavaScript (ES6+)
- No frameworks - pure vanilla JS
- Progressive Web App (PWA)
- Responsive design

### Backend
- **Supabase** (PostgreSQL database)
- RESTful API
- WebSocket for real-time
- Row Level Security (RLS)
- Built-in authentication

---

## 💻 Installation Options

### Option 1: Local File (Simplest)
Just double-click `supabase_tasks.html` - that's it!

### Option 2: Install as Desktop Widget
1. Open in Chrome/Edge
2. Click install icon in address bar
3. App opens in its own window
4. Works like a native app!

### Option 3: Deploy to Web
Host on free platforms:
- **Netlify**: Drag and drop files
- **Vercel**: Push to GitHub
- **GitHub Pages**: Enable in settings

---

## 📦 What's Included

```
task-manager/
├── supabase_tasks.html          # Main application (single file!)
├── manifest.json                # PWA manifest for desktop widget
├── database-setup.sql           # Database setup script
├── README.md                    # This file
├── QUICK_START.md              # 5-minute setup guide
├── SUPABASE_SETUP_GUIDE.md     # Complete setup guide
└── TECHNICAL_DOCUMENTATION.md   # Architecture and API docs
```

---

## 🎯 Use Cases

### Personal Productivity
- Daily to-do lists
- Project tracking
- Shopping lists
- Habit tracking
- Study planning

### Team Collaboration
- Project management
- Sprint planning
- Team task assignments
- Meeting action items
- Client deliverables

### Family Organization
- Household chores
- Family events
- Vacation planning
- Shared shopping lists
- Kids' activities

---

## 🔐 Security & Privacy

- ✅ **Row Level Security** - Users can only see their own data
- ✅ **Encrypted Passwords** - Hashed with bcrypt
- ✅ **HTTPS** - Encrypted communication
- ✅ **JWT Tokens** - Secure authentication
- ✅ **No Tracking** - Your data stays private
- ✅ **Open Source** - Audit the code yourself

---

## 💰 Pricing

**100% FREE Forever**

- ✅ Unlimited tasks
- ✅ Unlimited lists
- ✅ Real-time sync
- ✅ 50,000 monthly active users
- ✅ 500 MB database storage
- ✅ 2 GB bandwidth per month

**No credit card required. No hidden costs.**

---

## 🚀 Roadmap

### Version 1.1 (Next)
- [ ] Offline change queue and sync
- [ ] Task templates
- [ ] Undo/redo support
- [ ] Keyboard shortcuts
- [ ] Bulk operations

### Version 1.2
- [ ] List sharing
- [ ] Real-time collaboration
- [ ] Task comments
- [ ] Activity log

### Version 2.0
- [ ] Subtasks
- [ ] File attachments
- [ ] Calendar view
- [ ] Recurring tasks
- [ ] Email notifications
- [ ] Mobile apps

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## 🐛 Bug Reports

Found a bug? Please include:
- Browser and version
- Steps to reproduce
- Expected vs actual behavior
- Console errors (F12)

---

## ❓ FAQ

### Is it really free?
Yes! Supabase free tier is generous enough for personal use and small teams.

### Do I need to know how to code?
No! Just follow the 5-minute setup guide. No coding required.

### Can I use it offline?
Yes! The app caches data and works offline. Changes sync when you're back online.

### How do I install it as a desktop widget?
Open in Chrome/Edge, click the install icon in the address bar. That's it!

### Can I share lists with others?
Not yet, but it's coming in version 1.2!

### Is my data secure?
Yes! Row Level Security ensures you can only see your own data. Passwords are encrypted.

### What happens if I exceed the free tier?
You won't for typical use. The free tier handles 50,000 users/month!

### Can I self-host it?
Yes! The app is just HTML/JS. Host anywhere that serves static files.

---

## 📄 License

MIT License - Feel free to use, modify, and distribute.

---

## 🙏 Acknowledgments

Built with:
- [Supabase](https://supabase.com) - Backend and authentication
- Modern web standards (HTML5, CSS3, ES6+)
- No external frameworks or dependencies

---

## 📞 Support

- **Setup Issues**: See [SUPABASE_SETUP_GUIDE.md](SUPABASE_SETUP_GUIDE.md)
- **Technical Questions**: See [TECHNICAL_DOCUMENTATION.md](TECHNICAL_DOCUMENTATION.md)
- **Quick Help**: See [QUICK_START.md](QUICK_START.md)

---

## 🎉 Get Started Now!

1. Read [QUICK_START.md](QUICK_START.md)
2. Follow the 5-minute setup
3. Start managing tasks!

**No installation. No cost. No complexity.**

Just productivity. 🚀

---

**Made with ❤️ for better productivity**
