# 🚀 Supabase Task Manager - Complete Setup Guide

## Overview

This is a **100% FREE** real-time collaborative task manager that works as a desktop widget on Windows 11. No server costs, no subscriptions, no credit card required!

### ✨ Features

- ✅ Real-time synchronization (see changes instantly)
- ✅ User authentication (signup/login)
- ✅ Multiple task lists
- ✅ Task details: due dates, priorities, categories, assignees, notes
- ✅ Search and filters
- ✅ Dark mode
- ✅ Works offline (with automatic sync when online)
- ✅ Install as Windows 11 desktop widget (PWA)
- ✅ Completely free (Supabase free tier)

---

## 📋 Prerequisites

1. A web browser (Chrome, Edge, or Firefox recommended)
2. 5 minutes of your time
3. An email address (for Supabase account)

---

## 🔧 Setup Instructions

### Step 1: Create Supabase Account (2 minutes)

1. Go to [https://supabase.com](https://supabase.com)
2. Click "Start your project" (top right)
3. Sign up with GitHub or email (it's free, no credit card needed)
4. Verify your email if prompted

### Step 2: Create a New Project (1 minute)

1. Once logged in, click **"New Project"**
2. Fill in the form:
   - **Name**: `task-manager` (or any name you like)
   - **Database Password**: Create a strong password (you'll need this later)
   - **Region**: Choose the closest region to you
   - **Pricing Plan**: Leave on **"Free"** (don't worry, it's selected by default)
3. Click **"Create new project"**
4. Wait 1-2 minutes for the project to be created ☕

### Step 3: Get Your API Credentials (30 seconds)

1. Once your project is ready, go to **Settings** (⚙️ icon on left sidebar)
2. Click **API** in the left menu
3. You'll see two important values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public** key (under "Project API keys", looks like: `eyJhbGc...`)
4. **Keep this tab open** - you'll need these values in Step 5

### Step 4: Create Database Tables (1 minute)

1. In your Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **"New query"**
3. Copy and paste this SQL code:

```sql
-- Create lists table
CREATE TABLE lists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create tasks table
CREATE TABLE tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES auth.users NOT NULL,
    title TEXT NOT NULL,
    notes TEXT,
    completed BOOLEAN DEFAULT FALSE,
    due_date DATE,
    priority TEXT CHECK (priority IN ('high', 'medium', 'low')),
    category TEXT,
    assignee TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Lists policies - users can only see their own lists
CREATE POLICY "Users can view their own lists"
    ON lists FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own lists"
    ON lists FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own lists"
    ON lists FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own lists"
    ON lists FOR DELETE
    USING (auth.uid() = user_id);

-- Tasks policies - users can see tasks in their lists
CREATE POLICY "Users can view tasks in their lists"
    ON tasks FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create tasks in their lists"
    ON tasks FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update tasks in their lists"
    ON tasks FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete tasks in their lists"
    ON tasks FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.user_id = auth.uid()
        )
    );

-- Create indexes for better performance
CREATE INDEX idx_lists_user_id ON lists(user_id);
CREATE INDEX idx_tasks_list_id ON tasks(list_id);
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_completed ON tasks(completed);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
```

4. Click **"Run"** (bottom right)
5. You should see "Success. No rows returned" ✅

### Step 5: Configure the Application (1 minute)

1. Open the `supabase_tasks.html` file in a text editor (Notepad, VS Code, etc.)
2. Find these lines near the top of the JavaScript section (around line 890):

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

3. Replace `YOUR_SUPABASE_URL_HERE` with your **Project URL** from Step 3
4. Replace `YOUR_SUPABASE_ANON_KEY_HERE` with your **anon public** key from Step 3
5. Save the file

**Example:**
```javascript
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI...';
```

### Step 6: Run the Application (30 seconds)

1. **Option A (Easiest)**: Double-click `supabase_tasks.html` to open in your default browser
2. **Option B**: Right-click `supabase_tasks.html` → "Open with" → Choose your browser
3. You should see the login/signup screen! 🎉

---

## 👤 First Time Usage

### Create Your Account

1. Click **"Create Account"**
2. Enter your name, email, and password
3. Click **"Create Account"**
4. Check your email for verification link (check spam folder if needed)
5. Click the verification link
6. Go back to the app and click **"Sign In"**
7. Enter your email and password

### Start Using the App

1. Once logged in, click **"+ New List"** to create your first list
2. Enter a name (e.g., "Work Tasks", "Personal", "Groceries")
3. Click **"Create List"**
4. Start adding tasks! You can:
   - Quick add: Type in the top box and press Enter
   - Detailed add: Click the ⚙️ icon to add due dates, priorities, etc.

---

## 🪟 Install as Windows 11 Widget (Optional)

### Chrome/Edge

1. Open the app in Chrome or Edge
2. Look for the **install icon** (➕ or 🖥️) in the address bar
3. Click it and select **"Install"**
4. The app will open in its own window
5. Pin it to taskbar for quick access!

### Alternative Method

1. In Chrome/Edge, click the **three dots menu** (⋮)
2. Go to **"Install Task Manager"** or **"Apps" → "Install this site as an app"**
3. Follow the prompts

The app will now:
- Open in a separate window (not a browser tab)
- Have its own icon in the Start menu
- Work like a native Windows application
- Sync in real-time across all devices

---

## 💡 Tips & Tricks

### Task Organization

- **Use categories** to group related tasks (Work, Personal, Urgent, etc.)
- **Set due dates** for time-sensitive items - they'll be color-coded:
  - 🔴 Red = Overdue
  - 🟡 Orange = Due within 3 days
  - Regular = Not urgent
- **Use priorities** to focus on what matters:
  - High = Red background
  - Medium = Orange background
  - Low = Blue background

### Collaboration (Coming Soon)

In a future update, you'll be able to:
- Share lists with other users
- Assign tasks to team members
- See who's working on what
- Get real-time updates when others make changes

### Keyboard Shortcuts

- **Enter** in quick-add box = Add task
- **Click task** = Edit task
- **Click checkbox** = Mark complete/incomplete

### Dark Mode

- Click the 🌙 icon in the top right
- Your preference is saved automatically

### Offline Mode

- The app works offline using cached data
- Changes are queued and synced when you're back online
- Look for the status indicator (green dot = online, red = offline)

---

## 🔧 Troubleshooting

### "Authentication error" when signing in

- Make sure you verified your email
- Check that your password is correct
- Try the "Forgot password" link in Supabase

### "Error loading lists" or "Error loading tasks"

- Check that you ran the SQL setup script correctly (Step 4)
- Make sure your API credentials are correct (Step 5)
- Open browser console (F12) to see detailed error messages

### Real-time updates not working

- Check your internet connection
- Make sure you're using the same account on all devices
- Refresh the page (F5)

### App won't install as widget

- Make sure you're using Chrome or Edge (not Firefox)
- The file must be served over HTTPS or localhost
- Try accessing via a local web server (see Advanced Setup below)

---

## 🚀 Advanced Setup (For Developers)

### Running with a Local Web Server

For the PWA (Progressive Web App) features to work fully, you should serve the app over HTTPS or localhost:

#### Option 1: Python

```bash
# Python 3
python -m http.server 8000

# Then visit: http://localhost:8000/supabase_tasks.html
```

#### Option 2: Node.js

```bash
# Install http-server globally
npm install -g http-server

# Run server
http-server

# Then visit: http://localhost:8080/supabase_tasks.html
```

#### Option 3: VS Code Live Server

1. Install "Live Server" extension in VS Code
2. Right-click `supabase_tasks.html`
3. Select "Open with Live Server"

### Deploying to a Web Server

You can host this app for free on:

1. **Netlify** (easiest)
   - Drag and drop the HTML file and manifest.json
   - Done! You get a free HTTPS URL

2. **Vercel**
   - Create account, drag and drop files
   - Automatic HTTPS

3. **GitHub Pages**
   - Create a repository
   - Upload files
   - Enable GitHub Pages in settings

---

## 📊 Supabase Free Tier Limits

Your app stays free forever with these generous limits:

- ✅ 500 MB database storage
- ✅ 50,000 monthly active users
- ✅ 2 GB bandwidth per month
- ✅ 500,000 Edge Function invocations
- ✅ Unlimited API requests

For typical personal use (even with 5-10 users), you'll never hit these limits!

---

## 🔐 Security Notes

### What's Secure

- ✅ User authentication through Supabase (industry-standard)
- ✅ Row Level Security (RLS) - users can only see their own data
- ✅ Passwords are hashed and never stored in plain text
- ✅ API keys are safe to expose (they're "anon" public keys)
- ✅ HTTPS encryption when hosted properly

### Best Practices

- Don't share your database password (from Step 2)
- Don't share your project's service_role key (only use anon key)
- Regularly update your Supabase project
- Use strong passwords for user accounts

---

## 🎯 Future Enhancements (Planned)

Version 2.0 will include:

- [ ] **List sharing** - Invite others to collaborate
- [ ] **Task templates** - Quick task presets
- [ ] **Subtasks** - Break down complex tasks
- [ ] **Task comments** - Discuss tasks with team
- [ ] **File attachments** - Attach documents/images
- [ ] **Calendar view** - See tasks by date
- [ ] **Statistics** - Productivity insights
- [ ] **Recurring tasks** - Daily/weekly repeating tasks
- [ ] **Task dependencies** - Link related tasks
- [ ] **Email notifications** - Get reminders
- [ ] **Mobile app** - Native iOS/Android apps

---

## 💬 Support

### Getting Help

If you run into issues:

1. Check the Troubleshooting section above
2. Review the Supabase documentation: https://supabase.com/docs
3. Open browser console (F12) to see error messages
4. Check that all steps were completed correctly

### Reporting Issues

Found a bug? Have a suggestion?

1. Check the browser console for errors (F12)
2. Note what you were doing when the issue occurred
3. Include your browser version
4. Document steps to reproduce

---

## 📄 License

This project is open source and free to use, modify, and distribute.

---

## 🙏 Credits

Built with:
- [Supabase](https://supabase.com) - Backend and authentication
- Pure HTML/CSS/JavaScript - No frameworks needed!
- Modern browser APIs - PWA, real-time subscriptions

---

**Enjoy your free, real-time, collaborative task manager!** 🎉

If you have questions or need help with setup, don't hesitate to ask!
