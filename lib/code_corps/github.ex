defmodule CodeCorps.Github do

  alias CodeCorps.{User, Repo}

  @token_url ""
  @client_id ""
  @client_secret ""

  @doc """
  Temporary function until the actual behavior is implemented.
  """
  def connect(user, code) do
    github_post(code)
    |> Tentacat.Client.new
    |> Tentacat.Users.me
    |> update_user(user)
  end

  defp update_user(%{github_id: _github_id} = github_info, user) do
    associate(user, github_info)
  end

  defp github_post(code) do
    with {:ok, response_struct} <- Tentacat.post(@token_url, %{
      client_id: @client_id,
      client_secret: @client_secret,
      code: code,
      accept: :json
    }) 
    do
      %{access_token: _access_token} = Tentacat.process_response(response_struct)
    else
      {:error, error_struct} -> error_struct
    end
  end

  def associate(user, params) do
    user
    |> User.github_associate_changeset(params)
    |> Repo.update()
  end
end
