defmodule Account do
  defstruct client: nil, balance: 0.0, entries: []

  def add_entry(%Account{entries: entries} = account, :deposit, value) do
    new_entries = [{:deposit, value} | entries]
    %{account | entries: new_entries}
  end

  def add_entry(%Account{entries: entries} = account, :withdraw, value) do
    new_entries = [{:withdraw, value} | entries]
    %{account | entries: new_entries}
  end

  def update_balance(account, :deposit, value) do
    %{account | balance: account.balance + value}
  end

  def update_balance(account, :withdraw, value) do
    %{account | balance: account.balance - value}
  end
end

defmodule Client do
  defstruct name: "", accounts: []
end

defmodule BankAccountServer do
  use GenServer
  import Account

  @name __MODULE__

  # Client API

  def start(client_id, initial_balance) do
    initial_state = %Account{client: client_id, balance: initial_balance}
    GenServer.start(@name, initial_state)
  end

  def deposit(account_id, value) do
    GenServer.call(account_id, {:deposit, value})
  end

  def withdraw(account_id, value) do
    GenServer.call(account_id, {:withdraw, value})
  end

  def balance(account_id) do
    GenServer.call(account_id, :balance)
  end

  def last_entries(account_id) do
    GenServer.call(account_id, :last_entries)
  end

  # Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:deposit, value}, _from, state) do
    new_state =
      state
      |> add_entry(:deposit, value)
      |> update_balance(:deposit, value)

    {:reply, {:ok, value}, new_state}
  end

  def handle_call({:withdraw, value}, _from, %{balance: balance} = state) when balance >= value do
    new_state =
      state
      |> add_entry(:withdraw, value)
      |> update_balance(:withdraw, value)

    {:reply, {:ok, value}, new_state}
  end

  def handle_call({:withdraw, _value}, _from, state) do
    reply = {:error, :insufficient_funds}
    {:reply, reply, state}
  end
end
