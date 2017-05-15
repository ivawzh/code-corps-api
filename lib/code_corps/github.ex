defmodule CodeCorps.Github do

  alias CodeCorps.{User, Repo}

  @api Application.get_env(:code_corps, :github_api)

  @doc """
  Posts code to github to receive an auth token, associates user with that
  auth token.

  Returns one of the following:

  - {:ok, %CodeCorps.User{}}
  - {:error, %Ecto.Changeset{}}
  - {:error, "some_github_error"}
  """
  def connect(user, code) do
    case code |> @api.connect do
      {:ok, github_auth_token} -> user |> associate(%{github_auth_token: github_auth_token})
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Associates user with an auth token

  Returns one of the following:

  - {:ok, %CodeCorps.User{}}
  - {:error, %Ecto.Changeset{}}
  """
  def associate(user, params) do
    user
    |> User.github_associate_changeset(params)
    |> Repo.update()
  end
end
