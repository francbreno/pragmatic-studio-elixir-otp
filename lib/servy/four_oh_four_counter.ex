defmodule Servy.FourOhFourCounter do
  use GenServer

  @name __MODULE__

  # Client API

  def start_link(initial_state \\ %{}) do
    GenServer.start_link(@name, initial_state, name: @name)
  end

  def bump_count(path) when is_binary(path) do
    GenServer.cast(@name, {:bump, path})
  end

  def get_count(path) when is_binary(path) do
    GenServer.call(@name, {:count, path})
  end

  def get_counts do
    GenServer.call(@name, :count_all)
  end

  # Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:bump, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {:noreply, new_state}
  end

  def handle_call({:count, path}, _from, state) do
    count = Map.get(state, path, 0)
    {:reply, count, state}
  end

  def handle_call(:count_all, _from, state) do
    {:reply, state, state}
  end
end
