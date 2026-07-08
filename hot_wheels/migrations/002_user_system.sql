-- ============================================================
-- Hot Wheels App — User System Migration
-- Execute in Supabase SQL Editor
-- ============================================================

-- Profiles (linked to auth.users)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, display_name, avatar_url)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), NEW.raw_user_meta_data->>'avatar_url');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Lists
CREATE TABLE IF NOT EXISTS lists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- List cars (junction, denormalized)
CREATE TABLE IF NOT EXISTS list_cars (
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    added_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (list_id, car_year, car_toy_num, car_model_name)
);

-- Friendships
CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES profiles(id),
    addressee_id UUID NOT NULL REFERENCES profiles(id),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(requester_id, addressee_id)
);

-- Groups
CREATE TABLE IF NOT EXISTS groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID NOT NULL REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS group_members (
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);

-- Group shared lists
CREATE TABLE IF NOT EXISTS group_lists (
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE,
    shared_by UUID REFERENCES profiles(id),
    shared_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (group_id, list_id)
);

-- Favorites (denormalized)
CREATE TABLE IF NOT EXISTS favorites (
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, car_year, car_toy_num, car_model_name)
);

-- View history
CREATE TABLE IF NOT EXISTS view_history (
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    viewed_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, car_year, car_toy_num, car_model_name)
);

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_cars ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE view_history ENABLE ROW LEVEL SECURITY;

-- profiles: readable by all, writable by owner
DROP POLICY IF EXISTS p_profiles_select ON profiles;
CREATE POLICY p_profiles_select ON profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS p_profiles_update ON profiles;
CREATE POLICY p_profiles_update ON profiles FOR UPDATE USING (auth.uid() = id);

-- lists: owner full access, public readable
DROP POLICY IF EXISTS p_lists_select ON lists;
CREATE POLICY p_lists_select ON lists FOR SELECT USING (auth.uid() = user_id OR is_public = true);
DROP POLICY IF EXISTS p_lists_insert ON lists;
CREATE POLICY p_lists_insert ON lists FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS p_lists_update ON lists;
CREATE POLICY p_lists_update ON lists FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS p_lists_delete ON lists;
CREATE POLICY p_lists_delete ON lists FOR DELETE USING (auth.uid() = user_id);

-- list_cars: follows list permissions
DROP POLICY IF EXISTS p_list_cars_select ON list_cars;
CREATE POLICY p_list_cars_select ON list_cars FOR SELECT USING (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND (user_id = auth.uid() OR is_public = true))
);
DROP POLICY IF EXISTS p_list_cars_insert ON list_cars;
CREATE POLICY p_list_cars_insert ON list_cars FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND user_id = auth.uid())
);
DROP POLICY IF EXISTS p_list_cars_delete ON list_cars;
CREATE POLICY p_list_cars_delete ON list_cars FOR DELETE USING (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND user_id = auth.uid())
);

-- friendships
DROP POLICY IF EXISTS p_friendships_select ON friendships;
CREATE POLICY p_friendships_select ON friendships FOR SELECT USING (auth.uid() IN (requester_id, addressee_id));
DROP POLICY IF EXISTS p_friendships_insert ON friendships;
CREATE POLICY p_friendships_insert ON friendships FOR INSERT WITH CHECK (auth.uid() = requester_id);
DROP POLICY IF EXISTS p_friendships_update ON friendships;
CREATE POLICY p_friendships_update ON friendships FOR UPDATE USING (auth.uid() = addressee_id);

-- groups
DROP POLICY IF EXISTS p_groups_select ON groups;
CREATE POLICY p_groups_select ON groups FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = groups.id AND user_id = auth.uid())
);
DROP POLICY IF EXISTS p_groups_insert ON groups;
CREATE POLICY p_groups_insert ON groups FOR INSERT WITH CHECK (auth.uid() = owner_id);
DROP POLICY IF EXISTS p_groups_delete ON groups;
CREATE POLICY p_groups_delete ON groups FOR DELETE USING (auth.uid() = owner_id);

-- group_members
DROP POLICY IF EXISTS p_group_members_select ON group_members;
CREATE POLICY p_group_members_select ON group_members FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members gm WHERE gm.group_id = group_members.group_id AND gm.user_id = auth.uid())
);
DROP POLICY IF EXISTS p_group_members_insert ON group_members;
CREATE POLICY p_group_members_insert ON group_members FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM groups WHERE id = group_members.group_id AND owner_id = auth.uid())
);

-- group_lists: visible to group members
DROP POLICY IF EXISTS p_group_lists_select ON group_lists;
CREATE POLICY p_group_lists_select ON group_lists FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);
DROP POLICY IF EXISTS p_group_lists_insert ON group_lists;
CREATE POLICY p_group_lists_insert ON group_lists FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);

-- favorites: user-only
DROP POLICY IF EXISTS p_favorites_select ON favorites;
CREATE POLICY p_favorites_select ON favorites FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS p_favorites_insert ON favorites;
CREATE POLICY p_favorites_insert ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS p_favorites_delete ON favorites;
CREATE POLICY p_favorites_delete ON favorites FOR DELETE USING (auth.uid() = user_id);

-- view_history: user-only
DROP POLICY IF EXISTS p_history_select ON view_history;
CREATE POLICY p_history_select ON view_history FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS p_history_insert ON view_history;
CREATE POLICY p_history_insert ON view_history FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- RPCs
-- ============================================================

-- Search profiles
CREATE OR REPLACE FUNCTION search_profiles(query TEXT)
RETURNS TABLE(id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY SELECT p.id, p.display_name, p.avatar_url
  FROM profiles p WHERE p.display_name ILIKE '%' || query || '%' LIMIT 20;
END; $$ LANGUAGE plpgsql;

-- Get friends (with profiles)
CREATE OR REPLACE FUNCTION get_friends(p_user_id UUID)
RETURNS TABLE(friendship_id UUID, friend_id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY
    SELECT f.id, p.id, p.display_name, p.avatar_url
    FROM friendships f
    JOIN profiles p ON p.id = CASE WHEN f.requester_id = p_user_id THEN f.addressee_id ELSE f.requester_id END
    WHERE (f.requester_id = p_user_id OR f.addressee_id = p_user_id) AND f.status = 'accepted';
END; $$ LANGUAGE plpgsql;

-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_lists_user ON lists(user_id);
CREATE INDEX IF NOT EXISTS idx_list_cars_list ON list_cars(list_id);
CREATE INDEX IF NOT EXISTS idx_friendships_requester ON friendships(requester_id);
CREATE INDEX IF NOT EXISTS idx_friendships_addressee ON friendships(addressee_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON friendships(status);
CREATE INDEX IF NOT EXISTS idx_group_members_user ON group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_group_lists_group ON group_lists(group_id);
CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_view_history_user ON view_history(user_id);
CREATE INDEX IF NOT EXISTS idx_view_history_viewed ON view_history(user_id, viewed_at DESC);
