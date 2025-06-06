defmodule RepartoWeb.DeliveryQueryController do
  use RepartoWeb, :controller

  alias Reparto.Coverage
  alias Reparto.Repo

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"lat" => lat, "lon" => lon}) do
    lat_number = String.to_float(lat)
    lon_number = String.to_float(lon)
    point = %Geo.Point{coordinates: {lon_number, lat_number}, srid: 4326}
    routes = Coverage.list_routes_close_to(point) |> Repo.preload(:company)
    render(conn, :index, lat: lat, lon: lon, routes: routes)
  end
end
