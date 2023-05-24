defmodule GroupchatBe.SocketHandler do
  @behaviour :cowboy_websocket

  @spec init(atom | %{:path => any, optional(any) => any}, any) ::
          {:cowboy_websocket, atom | %{:path => any, optional(any) => any}, %{registry_key: any}}
  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  @spec websocket_init(atom | %{:registry_key => any, optional(any) => any}) ::
          {:ok, atom | %{:registry_key => any, optional(any) => any}}
  def websocket_init(state) do
    Registry.GroupchatBe
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  @spec websocket_handle(
          {:text,
           binary
           | maybe_improper_list(
               binary | maybe_improper_list(any, binary | []) | byte,
               binary | []
             )},
          atom | %{:registry_key => any, optional(any) => any}
        ) :: {:reply, {:text, any}, atom | %{:registry_key => any, optional(any) => any}}
  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    message = payload["data"]["message"]
    IO.inspect(self())

    Registry.GroupchatBe
    |> Registry.dispatch(state.registry_key, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)

    {:reply, {:text, message}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
