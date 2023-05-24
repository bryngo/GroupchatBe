defmodule GroupchatBe do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: GroupchatBe.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.GroupchatBe
      )
    ]

    opts = [strategy: :one_for_one, name: GroupchatBe.Application]
    Supervisor.start_link(children, opts)
    GroupchatBe.Supervisor.start_link(name: GroupchatBe.Supervisor)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/[...]", GroupchatBe.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {GroupchatBe.Router, []}}
       ]}
    ]
  end
end
