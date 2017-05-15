defmodule CodeCorps.Github.TestAPI do
  def connect("valid_code"), do: {:ok, "test_auth_token"}
  def connect("bad_code"), do: {:error, "bad_verification_code"}
end
