defmodule CodeCorps.Repo.Migrations.RenameUserGithubIdToGithubAuthToken do
  use Ecto.Migration

  def change do
    rename table(:users), :github_id, to: :github_auth_token
  end
end
