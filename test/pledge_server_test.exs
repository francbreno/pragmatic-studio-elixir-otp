defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "must start a long living process" do
    pid = PledgeServer.start()
    
    assert Process.alive?(pid)
  end

  test "Must create a new pledge" do
    pid = PledgeServer.start()
    
    id = PledgeServer.create_pledge("Max", 300)

    assert id != nil
  end

  test "Must return the more recent pledges" do
    pid = PledgeServer.start()

    PledgeServer.create_pledge("Ted", 200)
    PledgeServer.create_pledge("Jack", 100)
    PledgeServer.create_pledge("Pong", 300)
    PledgeServer.create_pledge("Max", 200)

    assert [{"Max", 200}, {"Pong", 300}, {"Jack", 100}] = PledgeServer.recent_pledges()
  end
end
