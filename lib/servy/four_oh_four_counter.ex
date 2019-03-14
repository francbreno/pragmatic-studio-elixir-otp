defmodule Servy.FourOhFourCounter do
  
  @name __MODULE__

  def start(initial_state \\ %{}) do
    pid = spawn(__MODULE__, :loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(path) when is_binary(path) do
    send(@name, {self, :bump, path})
  end

  def get_count(path) when is_binary(path) do
    send(@name, {self, :count, path})

    receive do {:response, count} -> count end
  end

  def get_counts do
    send(@name, {self, :count_all})

    receive do {:response, count_all} -> count_all end
  end

  def loop(state) do
    receive do
      {sender, :bump, path} ->
        new_state = Map.update(state, path, 1, &(&1 + 1))
        loop(new_state)
      {sender, :count, path} ->
        count = Map.get(state, path)
        send(sender, {:response, count})
        loop(state)
      {sender, :count_all} ->
        send(sender, {:response, state})
        loop(state)
      _ ->
        IO.puts "Invalid message"
        loop(state)
    end
  end
end