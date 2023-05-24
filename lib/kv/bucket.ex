defmodule GroupchatBe.Bucket do
  use Agent, restart: :temporary

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> [] end)
  end

  @doc """
  Gets a value from the `bucket` by `key`.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, value) do
    # Here is the client code
    Agent.update(bucket, fn state ->
      # Here is the server code
      Map.put(state, key, value)
    end)

    # Back to the client code
  end

  @doc """
  Deletes `key` from `bucket`.
  Returns the current value of `key`, if `key` exists.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, fn dict ->
      Map.pop(dict, key)
    end)
  end

  def add_user(bucket, user) do
    Agent.update(bucket, fn state ->
      [user | state]
    end)
  end

  def get_users(bucket) do
    Agent.get(bucket, fn users -> users end)
  end
end
