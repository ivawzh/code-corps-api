defmodule CodeCorps.Github do

  alias CodeCorps.{User, Task, Repo}

  require Logger

  @doc """
  Temporary function until the actual behavior is implemented.
  """
  def connect(user, _code), do: {:ok, user}

  def associate(user, params) do
    user
    |> User.github_associate_changeset(params)
    |> Repo.update()
  end

  def create_issue(task, current_user, github_owner, github_repo) do
    access_token = current_user.github_access_token || default_user_token() # need to create the Github user for this token
    client = Tentacat.Client.new(%{access_token: access_token})
    request = Tentacat.Issues.create(
      github_owner,
      github_repo,
      Map.take(task, [:title, :body]),
      client
    )
    case request do
      {:ok, response} ->
        github_id = response.body["id"] |> String.to_integer()

        task
        |> Task.github_changeset(%{"github_id" => github_id})
        |> Repo.update()
      {:error, error} ->
        Logger.error "Could not create issue for Task ID: #{task.id}. Error: #{error}"
        {:ok, task}
    end
  end

  defp default_user_token do
    System.get_env("GITHUB_DEFAULT_USER_TOKEN")
  end
end
