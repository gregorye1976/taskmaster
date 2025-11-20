# ⚡ Quick Start Guide - 5 Minute Setup

Don't want to read the full guide? Follow these steps to get running in 5 minutes:

## 1️⃣ Create Supabase Account (2 min)

1. Visit [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Sign up (free, no credit card)
4. Create new project named "task-manager"
5. Choose free tier, pick your region
6. Wait for project to initialize

## 2️⃣ Setup Database (1 min)

1. In Supabase dashboard, go to **SQL Editor**
2. Click **"New query"**
3. Copy the entire SQL script from `database-setup.sql` file
4. Paste and click **"Run"**
5. You should see "Success. No rows returned"

## 3️⃣ Get API Keys (30 sec)

1. Go to **Settings** → **API** in Supabase dashboard
2. Copy two values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)

## 4️⃣ Configure App (30 sec)

1. Open `supabase_tasks.html` in text editor
2. Find lines ~890:
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
   ```
3. Replace with your actual values from step 3
4. Save file

## 5️⃣ Run App (30 sec)

1. Double-click `supabase_tasks.html`
2. Click "Create Account"
3. Sign up with email
4. Verify email (check inbox)
5. Sign in and start using!

## 🎉 You're Done!

Now you can:
- Create lists
- Add tasks
- Set due dates, priorities, categories
- Install as desktop widget
- Use dark mode
- Work offline

---

## Quick Tips

### Essential Features

- **Quick Add**: Type in top box and press Enter
- **Detailed Add**: Click ⚙️ icon for full task details
- **Mark Complete**: Click checkbox on task
- **Edit Task**: Click on the task itself
- **Dark Mode**: Click 🌙 icon
- **Filters**: All / Active / Completed buttons
- **Search**: Type in search box

### Color Coding

- 🔴 **Red text** = Overdue task
- 🟡 **Orange text** = Due within 3 days
- **Red background** = High priority
- **Orange background** = Medium priority
- **Blue background** = Low priority

### Install as Widget (Chrome/Edge)

1. Look for install icon (➕) in address bar
2. Click "Install"
3. Done! Now it's a desktop app

---

## Need More Help?

See `SUPABASE_SETUP_GUIDE.md` for:
- Detailed troubleshooting
- Advanced features
- Deployment options
- Security information

## Common Issues

**Can't sign in?**
→ Verify your email first (check spam folder)

**No lists showing?**
→ Make sure you ran the SQL setup script

**Real-time not working?**
→ Check internet connection, refresh page

**Install not working?**
→ Use Chrome/Edge, serve over localhost (see advanced setup)

---

**That's it! You're ready to start managing tasks!** ✅
