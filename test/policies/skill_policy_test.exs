defmodule CodeCorps.SkillPolicyTest do
  use CodeCorps.PolicyCase

  import CodeCorps.SkillPolicy, only: [create?: 1]

  describe "create?" do
    test "returns true when user is an admin" do
      user = build(:user, admin: true)
      assert create?(user) 
    end

    test "returns false if user is not an admin" do
      user = build(:user, admin: false)
      refute create?(user) 
    end
  end
end
