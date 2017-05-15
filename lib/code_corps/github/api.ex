defmodule CodeCorps.Github.API do
  @client_secret Application.get_env(:code_corps, :github_client_secret)
  @client_id Application.get_env(:code_corps, :github_client_id)

  @base_connect_params %{
    client_id: @client_id,
    client_secret: @client_secret
  }

  def connect(code) do
    with {:ok, %HTTPoison.Response{body: response}} <- code |> build_connect_params() |> do_connect(),
      {:ok, %{"access_token" => access_token}} <- response |> Poison.decode
    do
      {:ok, access_token}
    else
      {:ok, %{"error" => error}} -> {:error, error}
    end
  end

  @connect_url "https://github.com/login/oauth/access_token"

  defp do_connect(params) do
    HTTPoison.post(@connect_url, "", [{"Accept", "application/json"}], [params: params])
  end

  defp build_connect_params(code),
    do: @base_connect_params |> Map.put(:code, code)
end
