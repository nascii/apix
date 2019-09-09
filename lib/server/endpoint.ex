defmodule Server.Endpoint do
  @moduledoc false

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  post "/events" do
    {status, body} =
      case conn.body_params do
	%{"events" => events} -> {200, process_events(events)}
	_                     -> {422, missing_events()}
      end
    send_resp(conn, status, body)
  end

  defp process_events(events) when is_list(events) do
    Poison.encode!(%{response: "received events"})
  end
  defp process_events(_) do
    Poison.encode!(%{response: "no events received"})
  end
  defp missing_events do
    Poison.encode!(%{error: "expected events"})
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
