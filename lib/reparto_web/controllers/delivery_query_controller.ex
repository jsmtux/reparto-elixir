defmodule RepartoWeb.DeliveryQueryController do
  use RepartoWeb, :controller

  alias Reparto.Coverage
  alias Reparto.Repo

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"lat" => lat, "lon" => lon}) do
    point = %Geo.Point{coordinates: {lat, lon}, srid: 4326}
    routes = Coverage.list_routes_close_to(point) |> Repo.preload(:company)
    render(conn, :index, lat: lat, lon: lon, routes: routes)
  end
end
