defmodule RepartoWeb.DeliveryQueryController do
  use RepartoWeb, :controller

  alias Reparto.Directory
  alias Reparto.Coverage
  alias Reparto.Catalog
  alias Reparto.Repo

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"lat" => lat, "lon" => lon}) do
    lat_number = String.to_float(lat)
    lon_number = String.to_float(lon)
    point = %Geo.Point{coordinates: {lon_number, lat_number}, srid: 4326}
    routes = Coverage.list_routes_close_to(point) |> Repo.preload(:company)
    render(conn, :index, lat: lat, lon: lon, routes: routes)
  end

  def show(conn, %{"company_id" => company_id, "route_id" => route_id}) do
    company = Directory.get_company!(company_id)
    route = Coverage.get_route!(route_id)
    products = Catalog.list_products(company)
    %{points: points} = route
    geojson_string = Geo.JSON.encode!(points) |> Jason.encode!
    render(conn, :show, company: company, route: route, products: products, geojson_string: geojson_string, day_of_week: get_day_str(route.day_of_week))
  end

  defp get_day_str(dow) do
    case dow do
     1 -> "Monday"
     2 -> "Tuesday"
     3 -> "Wednesday"
     4 -> "Thursday"
     5 -> "Friday"
     6 -> "Saturday"
     7 -> "Sunday"
    end
  end
end
