# 🚀 GitHub Pages Deployment Guide - Secure Setup

## Overview

This guide walks you through deploying the Task Manager application to GitHub Pages securely, with protected API credentials and admin-only user management.

## 🔐 Security Model

### Key Security Features

1. **No Public Signup** - Regular signup is disabled in the main app
2. **Admin Panel** - Separate interface for creating users (admin-only access)
3. **Protected Credentials** - Supabase URL and API key stored in gitignored `config.json`
4. **Row Level Security** - Database policies prevent unauthorized access
5. **First User is Admin** - Automatic admin creation for initial setup

---

## 📋 Prerequisites

- GitHub account
- Supabase account (free tier)
- Git installed on your computer
- Text editor (VS Code, Sublime, etc.)

---

## 🛠️ Step 1: Setup Supabase Database

### 1.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign in or create account
3. Click **"New Project"**
4. Fill in:
   - **Name**: task-manager-prod
   - **Database Password**: Create strong password (save it!)
   - **Region**: Choose closest to your users
   - **Plan**: Free
5. Click **"Create new project"**
6. Wait 1-2 minutes for provisioning

### 1.2 Run Database Setup

1. In Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **"New query"**
3. Copy entire contents of `database-setup-enhanced.sql`
4. Paste into editor
5. Click **"Run"** (bottom right)
6. You should see "Success. No rows returned" ✅

### 1.3 Disable Public Signups

1. In Supabase dashboard, go to **Authentication** → **Providers**
2. Click **Email** provider
3. **UNCHECK** "Enable email signup"
4. Click **Save**

This prevents users from self-registering through the main app.

### 1.4 Get API Credentials

1. Go to **Settings** → **API** (left sidebar)
2. Copy these two values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)
3. Keep this tab open - you'll need these values soon

---

## 🗂️ Step 2: Setup GitHub Repository

### 2.1 Create GitHub Repository

1. Go to [github.com](https://github.com)
2. Click **"New"** (green button, top right)
3. Fill in:
   - **Repository name**: task-manager (or your choice)
   - **Description**: Real-time collaborative task manager
   - **Public** or **Private** (either works)
   - **DO NOT** initialize with README (we have files already)
4. Click **"Create repository"**

### 2.2 Prepare Local Files

1. Create a new folder on your computer: `task-manager-deploy`
2. Copy these files into that folder:
   - `supabase_tasks.html` (will be renamed)
   - `admin-panel.html`
   - `config.js`
   - `config.example.json`
   - `.gitignore`
   - `manifest.json`

3. **IMPORTANT**: Rename `supabase_tasks.html` to `index.html`
   - This makes it the default page on GitHub Pages

### 2.3 Create config.json (NOT COMMITTED)

1. In the `task-manager-deploy` folder, create a new file: `config.json`
2. Copy this content:

```json
{
  "supabaseUrl": "YOUR_ACTUAL_SUPABASE_URL",
  "supabaseAnonKey": "YOUR_ACTUAL_ANON_KEY"
}
```

3. Replace `YOUR_ACTUAL_SUPABASE_URL` with your Supabase Project URL
4. Replace `YOUR_ACTUAL_ANON_KEY` with your anon public key
5. Save the file

**IMPORTANT**: The `.gitignore` file ensures `config.json` is NEVER committed to GitHub!

### 2.4 Initialize Git Repository

Open terminal/command prompt in the `task-manager-deploy` folder:

```bash
# Initialize git
git init

# Add all files (config.json will be ignored due to .gitignore)
git add .

# Verify config.json is NOT staged (should not appear in list)
git status

# Commit files
git commit -m "Initial commit: Task Manager with admin panel"

# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/task-manager.git

# Push to GitHub
git push -u origin main
```

**Verify**: Go to your GitHub repository and confirm `config.json` is NOT there!

---

## 🌐 Step 3: Deploy to GitHub Pages

### 3.1 Enable GitHub Pages

1. In your GitHub repository, click **Settings** (top menu)
2. Scroll down left sidebar, click **Pages**
3. Under "Source":
   - Branch: **main** (or master)
   - Folder: **/ (root)**
4. Click **Save**
5. Wait 1-2 minutes for deployment
6. GitHub will show your site URL: `https://YOUR_USERNAME.github.io/task-manager/`

### 3.2 Configure CORS (if needed)

GitHub Pages uses HTTPS automatically, which is perfect for Supabase. No additional configuration needed!

---

## 🔐 Step 4: Handle config.json for GitHub Pages

### The Problem

GitHub Pages can't use files that aren't committed (like `config.json`). We need a different solution.

### Solution: Use GitHub Secrets + GitHub Actions

#### 4.1 Create GitHub Secrets

1. In your GitHub repository, go to **Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"**
3. Create two secrets:

**Secret 1:**
- Name: `SUPABASE_URL`
- Value: Your Supabase Project URL

**Secret 2:**
- Name: `SUPABASE_ANON_KEY`
- Value: Your anon public key

4. Click **"Add secret"** for each

#### 4.2 Create GitHub Actions Workflow

In your local `task-manager-deploy` folder:

1. Create folder structure: `.github/workflows/`
2. Create file: `.github/workflows/deploy.yml`
3. Add this content:

```yaml
name: Deploy to GitHub Pages with Config

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Create config.json
        run: |
          cat > config.json << EOF
          {
            "supabaseUrl": "${{ secrets.SUPABASE_URL }}",
            "supabaseAnonKey": "${{ secrets.SUPABASE_ANON_KEY }}"
          }
          EOF

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

4. Commit and push:

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Actions deployment workflow"
git push
```

#### 4.3 Enable GitHub Actions for Pages

1. Go to **Settings** → **Pages**
2. Under "Build and deployment":
   - Source: **GitHub Actions**
3. Click **Save**

The workflow will run automatically and deploy your site with the config file!

---

## 👤 Step 5: Create First Admin User

### 5.1 Access Admin Panel

1. Go to your GitHub Pages URL: `https://YOUR_USERNAME.github.io/task-manager/admin-panel.html`
2. You'll see a login screen

### 5.2 Create Your Admin Account

**First Time Only:**

If no users exist yet, you'll need to create the first one directly:

1. Go to Supabase dashboard
2. Click **Authentication** → **Users**
3. Click **"Add user"** → **"Create new user"**
4. Fill in:
   - **Email**: your admin email
   - **Password**: strong password
   - **Auto Confirm User**: YES (check this!)
5. Click **"Create user"**

### 5.3 Complete Admin Setup

1. Go back to admin panel: `https://YOUR_USERNAME.github.io/task-manager/admin-panel.html`
2. Sign in with your email and password
3. You'll see "First Time Setup" screen
4. Enter your full name
5. Click **"Create Admin Account"**
6. ✅ You're now an admin!

---

## 👥 Step 6: Create Additional Users

### 6.1 Using Admin Panel

1. Go to admin panel and sign in
2. Under "Create New User" section:
   - Enter user's email
   - Enter user's full name
   - Click **"Generate Password"** or enter custom password
   - Choose role: **Regular User** or **Administrator**
3. Click **"Create User"**
4. **IMPORTANT**: Copy the generated password and send it to the user securely

### 6.2 User's First Login

1. User goes to: `https://YOUR_USERNAME.github.io/task-manager/`
2. They see a login screen (no signup option!)
3. They log in with:
   - Email you provided
   - Temporary password you provided
4. **Recommend**: User should change password in Supabase

---

## 🔒 Step 7: Security Best Practices

### 7.1 Protect Your Secrets

- ✅ Never commit `config.json` to GitHub
- ✅ Use GitHub Secrets for credentials
- ✅ Don't share your Supabase database password
- ✅ Don't share your service_role key (we don't use it)
- ✅ Regularly rotate admin passwords

### 7.2 User Management

- ✅ Only create users for trusted individuals
- ✅ Use strong temporary passwords
- ✅ Tell users to change password after first login
- ✅ Review user list regularly
- ✅ Delete inactive users

### 7.3 Database Security

- ✅ Row Level Security (RLS) is enabled automatically
- ✅ Users can only see their own data and shared data
- ✅ Audit the `database-setup-enhanced.sql` policies
- ✅ Monitor Supabase dashboard for unusual activity

---

## 🧪 Step 8: Testing

### 8.1 Test Admin Panel

1. Go to admin panel URL
2. Sign in as admin
3. Create a test user
4. Verify user appears in user list
5. Test "Make Admin" / "Remove Admin" buttons
6. Test "Delete" button (use test user)

### 8.2 Test Main App

1. Go to main app URL: `https://YOUR_USERNAME.github.io/task-manager/`
2. Verify NO signup button exists
3. Sign in with regular user credentials
4. Create a list
5. Add tasks
6. Test all features (priorities, due dates, etc.)

### 8.3 Test Collaboration

1. Sign in as User A
2. Create a list
3. Add tasks
4. Sign out
5. Sign in as User B
6. Verify User B cannot see User A's lists (RLS working!)

---

## 🐛 Troubleshooting

### "Configuration not found" Error

**Cause**: config.json not loaded properly

**Fix**:
1. Check GitHub Actions workflow ran successfully (check Actions tab)
2. Verify GitHub Secrets are set correctly
3. Try re-running the workflow manually

### "Access denied" in Admin Panel

**Cause**: User is not marked as admin

**Fix**:
1. Go to Supabase dashboard
2. Click **Table Editor** → **user_profiles**
3. Find the user
4. Set `is_admin` column to `true`
5. Click Save

### Users Can See Each Other's Data

**Cause**: RLS policies not applied correctly

**Fix**:
1. Go to Supabase SQL Editor
2. Run this to check RLS:
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```
3. All tables should show `rowsecurity = true`
4. If not, re-run `database-setup-enhanced.sql`

### Admin Panel Won't Create Users

**Cause**: Need to use service_role key for admin functions

**Fix**: This is expected behavior. For now, create users through Supabase dashboard directly. We'll fix the admin panel in next update.

**Temporary Workaround**:
1. Go to Supabase dashboard
2. **Authentication** → **Users**
3. Click **"Add user"**
4. After creating auth user, add to `user_profiles` table manually

---

## 📊 Step 9: Monitoring

### 9.1 Supabase Dashboard

Monitor your application:

1. **Database** → **Table Editor**: See lists, tasks, users
2. **Authentication** → **Users**: See login history
3. **Database** → **Logs**: Check for errors
4. **Storage**: Monitor database size

### 9.2 GitHub Pages

- **Settings** → **Pages**: Check deployment status
- **Actions**: View deployment logs
- **Insights** → **Traffic**: See visitor stats (if public repo)

---

## 🔄 Step 10: Updates and Maintenance

### 10.1 Updating the Application

When you make changes:

```bash
# Make your changes to files
git add .
git commit -m "Description of changes"
git push
```

GitHub Actions will automatically redeploy!

### 10.2 Updating Database Schema

If you need to modify database:

1. Create migration SQL file
2. Test locally first
3. Run in Supabase SQL Editor
4. Document changes

### 10.3 Backup

**Important**: Supabase free tier doesn't include automatic backups!

**Manual Backup**:
1. Supabase dashboard → **Database** → **Backups**
2. Click **"Download backup"**
3. Store securely
4. Backup regularly (weekly recommended)

---

## 📝 Step 11: Custom Domain (Optional)

### 11.1 Buy Domain

1. Buy domain from registrar (Namecheap, Google Domains, etc.)
2. Example: `tasks.yourdomain.com`

### 11.2 Configure DNS

Add these DNS records:

```
Type: CNAME
Name: tasks (or @ for root domain)
Value: YOUR_USERNAME.github.io
TTL: 3600
```

### 11.3 Configure GitHub Pages

1. **Settings** → **Pages**
2. Under "Custom domain":
   - Enter: `tasks.yourdomain.com`
   - Click **Save**
3. Check **"Enforce HTTPS"** (wait for SSL provisioning)

---

## ✅ Final Checklist

Before going live:

- [ ] Database setup complete
- [ ] Public signups disabled in Supabase
- [ ] GitHub repository created
- [ ] `.gitignore` prevents config.json from being committed
- [ ] GitHub Secrets configured
- [ ] GitHub Actions workflow deployed
- [ ] First admin user created
- [ ] Admin panel accessible and working
- [ ] Main app accessible (no signup button visible)
- [ ] Test user created and verified
- [ ] RLS policies working (users can't see each other's data)
- [ ] All features tested
- [ ] Backup strategy in place

---

## 🎉 You're Done!

Your Task Manager is now deployed securely on GitHub Pages!

**Access Points**:
- Main App: `https://YOUR_USERNAME.github.io/task-manager/`
- Admin Panel: `https://YOUR_USERNAME.github.io/task-manager/admin-panel.html`

**Share main app URL with users** (admin panel URL should be kept private!)

---

## 📚 Additional Resources

- **Supabase Docs**: https://supabase.com/docs
- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **GitHub Actions Docs**: https://docs.github.com/en/actions

---

## 🆘 Getting Help

If you encounter issues:

1. Check the Troubleshooting section above
2. Review GitHub Actions logs for deployment errors
3. Check Supabase logs for database errors
4. Check browser console (F12) for JavaScript errors

---

**Security Reminder**: Never commit sensitive credentials to GitHub. Always use GitHub Secrets or environment variables for production deployments!
