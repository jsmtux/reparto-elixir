defmodule RepartoWeb.HomeController do
  use RepartoWeb, :controller

  def index(conn, _params) do
    coords = %{"lat" => 0.0, "lon" => 0.0}
    render(conn, :index, coords: coords)
  end
end
