defmodule GroupchatBe.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = GroupchatBe.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert GroupchatBe.Bucket.get(bucket, "milk") == nil

    GroupchatBe.Bucket.put(bucket, "milk", 3)
    assert GroupchatBe.Bucket.get(bucket, "milk") == 3
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(GroupchatBe.Bucket, []).restart == :temporary
  end
end
