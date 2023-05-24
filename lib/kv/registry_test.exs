defmodule GroupchatBe.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(GroupchatBe.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert GroupchatBe.Registry.lookup(registry, "shopping") == :error

    GroupchatBe.Registry.create(registry, "shopping")
    assert {:ok, bucket} = GroupchatBe.Registry.lookup(registry, "shopping")

    GroupchatBe.Bucket.put(bucket, "milk", 1)
    assert GroupchatBe.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    GroupchatBe.Registry.create(registry, "shopping")
    {:ok, bucket} = GroupchatBe.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert GroupchatBe.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    GroupchatBe.Registry.create(registry, "shopping")
    {:ok, bucket} = GroupchatBe.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    assert GroupchatBe.Registry.lookup(registry, "shopping") == :error
  end
end
