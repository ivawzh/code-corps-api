defmodule CodeCorps.PasswordResetController do
  use CodeCorps.Web, :controller

  alias CodeCorps.{User,AuthToken, TokenController}
  alias Ecto.Changeset

  @doc"""
  reset_password should take a token, password, and password_confirmation and check
  1. the token exists in AuthToken model & verifies it with Phoenix.Token.verify
  2. password & password_confirmation match
  and return email. 422 if pwd do not match or auth token does not exist
  """
  def reset_password(conn, %{"token" => token, "password" => password, "password_confirmation" => password_confirmation}) do
    with %AuthToken{value: auth_token, user_id: user_id} <- Repo.get_by(CodeCorps.AuthToken, %{ value: token }),
      {:ok, _} <- Phoenix.Token.verify(CodeCorps.Endpoint, "user", auth_token, max_age: 1209600) do
        user = Repo.get(User, user_id)
        with %Changeset{valid?: true} = changeset <- User.reset_password_changeset(user, 
                                                                       %{password: password, password_confirmation: password_confirmation}),
             {:ok, user} <- Repo.update(changeset) do
          conn
          |> TokenController.create(%{"username" => user.email, "password" => password})
        else
          %Changeset{valid?: false} -> 
            handle_reset_pswd_result(conn)
        end
    else
      nil ->
        handle_reset_pswd_result(conn)
    end
  end

  defp handle_reset_pswd_result(conn) do
    conn
    |> put_status(422)
    |> render(CodeCorps.ErrorView, "422.json-api")
  end

end
