-- ============================================================
-- Fix: RLS infinite recursion on group policies
-- Run this in Supabase SQL Editor
-- ============================================================

-- Drop all group-related policies first
DROP POLICY IF EXISTS p_groups_select ON groups;
DROP POLICY IF EXISTS p_groups_insert ON groups;
DROP POLICY IF EXISTS p_groups_delete ON groups;
DROP POLICY IF EXISTS p_group_members_select ON group_members;
DROP POLICY IF EXISTS p_group_members_insert ON group_members;
DROP POLICY IF EXISTS p_group_lists_select ON group_lists;
DROP POLICY IF EXISTS p_group_lists_insert ON group_lists;

-- groups: members see their groups, owners see theirs
CREATE POLICY p_groups_select ON groups FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = groups.id AND user_id = auth.uid())
    OR owner_id = auth.uid()
);
CREATE POLICY p_groups_insert ON groups FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY p_groups_delete ON groups FOR DELETE USING (auth.uid() = owner_id);

-- group_members: anyone can see members (not sensitive data)
CREATE POLICY p_group_members_select ON group_members FOR SELECT USING (true);
CREATE POLICY p_group_members_insert ON group_members FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM groups WHERE id = group_members.group_id AND owner_id = auth.uid())
);

-- group_lists: members of the group can see and share lists
CREATE POLICY p_group_lists_select ON group_lists FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);
CREATE POLICY p_group_lists_insert ON group_lists FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);
