defmodule Servy.GenericServer404 do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send(pid, {:call, self, message})

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})
        loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)   
        loop(new_state, callback_module)

      _ ->
        IO.puts "Invalid message"
        loop(state, callback_module)
    end
  end
end

defmodule Servy.FourOhFourCounterHandRolled do
  alias Servy.GenericServer404

  @name __MODULE__

  # Client API

  def start(initial_state \\ %{}) do
    IO.puts "Starting GenericServer404..."
    GenericServer404.start(__MODULE__, initial_state, @name)
  end

  def bump_count(path) when is_binary(path) do
    GenericServer404.cast(@name, {:bump, path})
  end

  def get_count(path) when is_binary(path) do
    GenericServer404.call(@name, {:count, path})
  end

  def get_counts do
    GenericServer404.call(@name, :count_all)
  end

  # Server Callbacks

  def handle_call({:count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end

  def handle_call(:count_all, state) do
    {state, state}
  end

  def handle_cast({:bump, path}, state) do
    Map.update(state, path, 1, &(&1 + 1))
  end
end