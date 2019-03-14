defmodule Servy.PledgeServer do

  @name __MODULE__

  # Client Interface

  def start(initial_state \\ []) do
    IO.puts "Starting the pledge server..."
    
    case Process.whereis(@name) do
      nil ->
        pid = spawn(@name, :listen_loop, [initial_state])
        Process.register(pid, @name)
        pid
      existing_pid ->
        existing_pid
    end
  end

  def create_pledge(name, amount) do
    send @name, {self(), :create_pledge, name, amount}

    receive do {:response, status} -> status end
  end

  def recent_pledges do
    send @name, {self(), :recent_pledges}

    # blocking
    receive do {:response, pledges} -> IO.inspect pledges end
  end

  def total_pledged do
    send @name, {self(), :total_pledged}
    
    receive do {:response, total} -> total end
  end

  # Server Interface

  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [ {name, amount} | most_recent_pledges ]
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)
      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
        send sender, {:response, total}
        listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to send pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end