defmodule Servy.SensorServer do
  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.minutes(60)
  end

  @name __MODULE__

  use GenServer

  # Client API

  def start do
    GenServer.start(@name, %State{}, name: @name)
  end

  def get_sensor_data() do
    GenServer.call(@name, :get_sensor_data)
  end

  def set_refresh_interval(time_in_ms) do
    GenServer.cast(@name, {:set_refresh_interval, time_in_ms})
  end

  # Server Callbacks

  def init(state) do
    sensor_data = run_tasks_to_get_sensor_data()
    initial_state = %{state | sensor_data: sensor_data}
    schedule_refresh(state.refresh_interval)
    {:ok, initial_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  def handle_cast({:set_refresh_interval, time_in_ms}, _from, state) do
    new_state = %{state | refresh_interval: time_in_ms}
    {:noreply, new_state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing the cash...")
    sensor_data = run_tasks_to_get_sensor_data()
    new_state = %{state | sensor_data: sensor_data}
    schedule_refresh(state.refresh_interval)
    {:noreply, new_state}
  end

  def handle_info(unexpected, state) do
    IO.puts("Can't touch this: #{inspect(unexpected)}")
    {:noreply, state}
  end

  defp schedule_refresh(interval) do
    Process.send_after(self(), :refresh, interval)
  end

  defp run_tasks_to_get_sensor_data() do
    IO.puts("Running tasks to get sensor data...")

    # Request for bigfoot is called first because we will await for the VideoCam requests in the pipeline below
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
