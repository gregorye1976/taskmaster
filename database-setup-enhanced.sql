-- =====================================================
-- Task Manager - Enhanced Database Setup
-- With User Management, Sharing, and Permissions
-- =====================================================

-- =====================================================
-- User Profiles Table (extends auth.users)
-- =====================================================
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    created_by UUID REFERENCES auth.users(id),
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login TIMESTAMPTZ
);

-- =====================================================
-- Lists Table (with owner)
-- =====================================================
CREATE TABLE lists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    owner_id UUID REFERENCES auth.users NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- List Shares Table (sharing lists with specific users)
-- =====================================================
CREATE TABLE list_shares (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE NOT NULL,
    shared_with_user_id UUID REFERENCES auth.users NOT NULL,
    shared_by_user_id UUID REFERENCES auth.users NOT NULL,
    permission TEXT CHECK (permission IN ('read', 'write', 'admin')) DEFAULT 'read',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(list_id, shared_with_user_id)
);

-- =====================================================
-- Tasks Table (enhanced with assignments)
-- =====================================================
CREATE TABLE tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE NOT NULL,
    created_by UUID REFERENCES auth.users NOT NULL,
    title TEXT NOT NULL,
    notes TEXT,
    completed BOOLEAN DEFAULT FALSE,
    due_date DATE,
    priority TEXT CHECK (priority IN ('high', 'medium', 'low')),
    category TEXT,
    assigned_to UUID REFERENCES auth.users,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

-- =====================================================
-- Task Shares Table (sharing individual tasks)
-- =====================================================
CREATE TABLE task_shares (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE NOT NULL,
    shared_with_user_id UUID REFERENCES auth.users NOT NULL,
    shared_by_user_id UUID REFERENCES auth.users NOT NULL,
    permission TEXT CHECK (permission IN ('read', 'write')) DEFAULT 'read',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(task_id, shared_with_user_id)
);

-- =====================================================
-- Activity Log Table (audit trail)
-- =====================================================
CREATE TABLE activity_log (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users NOT NULL,
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    details JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- Enable Row Level Security
-- =====================================================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- User Profiles Policies
-- =====================================================

-- Users can view all user profiles (for sharing/assignment features)
CREATE POLICY "Users can view all profiles"
    ON user_profiles FOR SELECT
    USING (auth.uid() IS NOT NULL);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON user_profiles FOR UPDATE
    USING (auth.uid() = id);

-- Only admins can insert user profiles (through admin panel)
CREATE POLICY "Admins can create profiles"
    ON user_profiles FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE id = auth.uid() AND is_admin = TRUE
        )
    );

-- =====================================================
-- Lists Policies
-- =====================================================

-- Users can view lists they own OR lists shared with them
CREATE POLICY "Users can view own or shared lists"
    ON lists FOR SELECT
    USING (
        auth.uid() = owner_id
        OR
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = lists.id 
            AND list_shares.shared_with_user_id = auth.uid()
        )
    );

-- Users can create their own lists
CREATE POLICY "Users can create own lists"
    ON lists FOR INSERT
    WITH CHECK (auth.uid() = owner_id);

-- Users can update lists they own OR have write/admin permission
CREATE POLICY "Users can update own or writable lists"
    ON lists FOR UPDATE
    USING (
        auth.uid() = owner_id
        OR
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = lists.id 
            AND list_shares.shared_with_user_id = auth.uid()
            AND list_shares.permission IN ('write', 'admin')
        )
    );

-- Users can delete only lists they own
CREATE POLICY "Users can delete own lists"
    ON lists FOR DELETE
    USING (auth.uid() = owner_id);

-- =====================================================
-- List Shares Policies
-- =====================================================

-- Users can view shares for lists they own or are shared with
CREATE POLICY "Users can view list shares"
    ON list_shares FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = list_shares.list_id 
            AND lists.owner_id = auth.uid()
        )
        OR
        shared_with_user_id = auth.uid()
    );

-- List owners can create shares
CREATE POLICY "List owners can create shares"
    ON list_shares FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = list_shares.list_id 
            AND lists.owner_id = auth.uid()
        )
    );

-- List owners can update shares
CREATE POLICY "List owners can update shares"
    ON list_shares FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = list_shares.list_id 
            AND lists.owner_id = auth.uid()
        )
    );

-- List owners can delete shares
CREATE POLICY "List owners can delete shares"
    ON list_shares FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = list_shares.list_id 
            AND lists.owner_id = auth.uid()
        )
    );

-- =====================================================
-- Tasks Policies
-- =====================================================

-- Users can view tasks in lists they have access to
CREATE POLICY "Users can view accessible tasks"
    ON tasks FOR SELECT
    USING (
        -- Tasks in lists they own
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.owner_id = auth.uid()
        )
        OR
        -- Tasks in lists shared with them
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = tasks.list_id 
            AND list_shares.shared_with_user_id = auth.uid()
        )
        OR
        -- Tasks specifically shared with them
        EXISTS (
            SELECT 1 FROM task_shares 
            WHERE task_shares.task_id = tasks.id 
            AND task_shares.shared_with_user_id = auth.uid()
        )
        OR
        -- Tasks assigned to them
        assigned_to = auth.uid()
    );

-- Users can create tasks in lists they have write access to
CREATE POLICY "Users can create tasks in writable lists"
    ON tasks FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.owner_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = tasks.list_id 
            AND list_shares.shared_with_user_id = auth.uid()
            AND list_shares.permission IN ('write', 'admin')
        )
    );

-- Users can update tasks in lists they have write access to OR tasks assigned to them
CREATE POLICY "Users can update writable or assigned tasks"
    ON tasks FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.owner_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = tasks.list_id 
            AND list_shares.shared_with_user_id = auth.uid()
            AND list_shares.permission IN ('write', 'admin')
        )
        OR
        EXISTS (
            SELECT 1 FROM task_shares 
            WHERE task_shares.task_id = tasks.id 
            AND task_shares.shared_with_user_id = auth.uid()
            AND task_shares.permission = 'write'
        )
        OR
        assigned_to = auth.uid()
    );

-- Users can delete tasks in lists they own or have admin access to
CREATE POLICY "Users can delete tasks in own or admin lists"
    ON tasks FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM lists 
            WHERE lists.id = tasks.list_id 
            AND lists.owner_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM list_shares 
            WHERE list_shares.list_id = tasks.list_id 
            AND list_shares.shared_with_user_id = auth.uid()
            AND list_shares.permission = 'admin'
        )
    );

-- =====================================================
-- Task Shares Policies
-- =====================================================

-- Users can view task shares for tasks they created or tasks shared with them
CREATE POLICY "Users can view task shares"
    ON task_shares FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM tasks 
            WHERE tasks.id = task_shares.task_id 
            AND tasks.created_by = auth.uid()
        )
        OR
        shared_with_user_id = auth.uid()
    );

-- Task creators can create shares
CREATE POLICY "Task creators can create shares"
    ON task_shares FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM tasks 
            WHERE tasks.id = task_shares.task_id 
            AND tasks.created_by = auth.uid()
        )
    );

-- Task creators can update shares
CREATE POLICY "Task creators can update shares"
    ON task_shares FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM tasks 
            WHERE tasks.id = task_shares.task_id 
            AND tasks.created_by = auth.uid()
        )
    );

-- Task creators can delete shares
CREATE POLICY "Task creators can delete shares"
    ON task_shares FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM tasks 
            WHERE tasks.id = task_shares.task_id 
            AND tasks.created_by = auth.uid()
        )
    );

-- =====================================================
-- Activity Log Policies
-- =====================================================

-- Users can view their own activity
CREATE POLICY "Users can view own activity"
    ON activity_log FOR SELECT
    USING (auth.uid() = user_id);

-- Anyone authenticated can insert activity logs
CREATE POLICY "Users can create activity logs"
    ON activity_log FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- Indexes for Performance
-- =====================================================

CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_user_profiles_is_admin ON user_profiles(is_admin);

CREATE INDEX idx_lists_owner_id ON lists(owner_id);
CREATE INDEX idx_lists_updated_at ON lists(updated_at);

CREATE INDEX idx_list_shares_list_id ON list_shares(list_id);
CREATE INDEX idx_list_shares_shared_with ON list_shares(shared_with_user_id);

CREATE INDEX idx_tasks_list_id ON tasks(list_id);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_completed ON tasks(completed);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_updated_at ON tasks(updated_at);

CREATE INDEX idx_task_shares_task_id ON task_shares(task_id);
CREATE INDEX idx_task_shares_shared_with ON task_shares(shared_with_user_id);

CREATE INDEX idx_activity_log_user_id ON activity_log(user_id);
CREATE INDEX idx_activity_log_created_at ON activity_log(created_at);
CREATE INDEX idx_activity_log_entity ON activity_log(entity_type, entity_id);

-- =====================================================
-- Functions and Triggers
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for lists
CREATE TRIGGER update_lists_updated_at
    BEFORE UPDATE ON lists
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for tasks
CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to update completed_at when task is completed
CREATE OR REPLACE FUNCTION update_task_completed_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed = TRUE AND OLD.completed = FALSE THEN
        NEW.completed_at = NOW();
    ELSIF NEW.completed = FALSE AND OLD.completed = TRUE THEN
        NEW.completed_at = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for task completion
CREATE TRIGGER update_task_completed_at_trigger
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_task_completed_at();

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_profiles (id, email, full_name, is_admin)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
        -- First user is admin
        NOT EXISTS (SELECT 1 FROM user_profiles)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile automatically
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- =====================================================
-- Views for easier querying
-- =====================================================

-- View: Lists with share count and collaborator info
CREATE VIEW lists_with_shares AS
SELECT 
    l.*,
    u.email as owner_email,
    u.full_name as owner_name,
    COUNT(DISTINCT ls.shared_with_user_id) as share_count
FROM lists l
LEFT JOIN user_profiles u ON l.owner_id = u.id
LEFT JOIN list_shares ls ON l.id = ls.list_id
GROUP BY l.id, u.email, u.full_name;

-- View: Tasks with assignment and sharing info
CREATE VIEW tasks_with_details AS
SELECT 
    t.*,
    creator.email as creator_email,
    creator.full_name as creator_name,
    assignee.email as assignee_email,
    assignee.full_name as assignee_name,
    l.name as list_name,
    COUNT(DISTINCT ts.shared_with_user_id) as share_count
FROM tasks t
LEFT JOIN user_profiles creator ON t.created_by = creator.id
LEFT JOIN user_profiles assignee ON t.assigned_to = assignee.id
LEFT JOIN lists l ON t.list_id = l.id
LEFT JOIN task_shares ts ON t.id = ts.task_id
GROUP BY t.id, creator.email, creator.full_name, assignee.email, assignee.full_name, l.name;

-- =====================================================
-- Setup Complete!
-- =====================================================
-- You should see: "Success. No rows returned"
-- 
-- Next steps:
-- 1. The first user to sign up will automatically be an admin
-- 2. Use the admin panel to create additional users
-- 3. Regular signup is now disabled in the main app
-- =====================================================
