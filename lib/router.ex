defmodule GroupchatBe.Router do
  use Plug.Router
  require EEx

  plug(Plug.Static,
    at: "/",
    from: :groupchat_be
  )

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  EEx.function_from_file(:defp, :application_html, "lib/application.html.eex", [])

  get "/" do
    GroupchatBe.Registry.create(GroupchatBe.Registry, "users")
    send_resp(conn, 200, application_html())
  end

  get "/dsa" do
    {:ok, pid} = GroupchatBe.Registry.lookup(GroupchatBe.Registry, "users")
    GroupchatBe.Bucket.add_user(pid, "user 1")
    IO.inspect(GroupchatBe.Bucket.get_users(pid))
    GroupchatBe.Bucket.add_user(pid, "user 2")
    IO.inspect(GroupchatBe.Bucket.get_users(pid))
    send_resp(conn, 200, "dsadasad")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
