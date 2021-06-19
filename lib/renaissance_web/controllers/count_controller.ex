defmodule RenaissanceWeb.CountController do
  use RenaissanceWeb, :controller

  def index(conn, _params) do
    count = Counter.value()
    Counter.increment()
    json(conn, %{counting: count})
  end
end
