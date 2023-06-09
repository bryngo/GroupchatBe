defmodule GroupchatBe.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: GroupchatBe.BucketSupervisor, strategy: :one_for_one},
      {GroupchatBe.Registry, name: GroupchatBe.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
