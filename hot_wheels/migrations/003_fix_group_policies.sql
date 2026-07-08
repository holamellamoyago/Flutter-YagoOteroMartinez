-- ============================================================
-- Fix: RLS infinite recursion on group_members policies
-- Run this in Supabase SQL Editor
-- ============================================================

-- Security definer function (bypasses RLS)
CREATE OR REPLACE FUNCTION is_group_member(p_group_id UUID, p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM group_members
    WHERE group_id = p_group_id AND user_id = p_user_id
  );
$$;

-- Fix: groups SELECT policy
DROP POLICY IF EXISTS p_groups_select ON groups;
CREATE POLICY p_groups_select ON groups FOR SELECT USING (
    is_group_member(groups.id, auth.uid())
    OR owner_id = auth.uid()
);

-- Fix: group_members SELECT policy (was self-referencing!)
DROP POLICY IF EXISTS p_group_members_select ON group_members;
CREATE POLICY p_group_members_select ON group_members FOR SELECT USING (
    is_group_member(group_members.group_id, auth.uid())
    OR EXISTS (SELECT 1 FROM groups WHERE id = group_members.group_id AND owner_id = auth.uid())
);

-- Fix: group_lists SELECT policy
DROP POLICY IF EXISTS p_group_lists_select ON group_lists;
CREATE POLICY p_group_lists_select ON group_lists FOR SELECT USING (
    is_group_member(group_lists.group_id, auth.uid())
);

-- Fix: group_lists INSERT policy
DROP POLICY IF EXISTS p_group_lists_insert ON group_lists;
CREATE POLICY p_group_lists_insert ON group_lists FOR INSERT WITH CHECK (
    is_group_member(group_lists.group_id, auth.uid())
);
