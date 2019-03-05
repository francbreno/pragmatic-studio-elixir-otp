defmodule Timer do
  def remind(reminder, time_in_seconds) do
    spawn(fn ->
      :timer.sleep(time_in_seconds * 1000)
      IO.puts """
      New Reminder
      ******************************************\t
      #{reminder}
      ******************************************
      """
    end)
  end
end