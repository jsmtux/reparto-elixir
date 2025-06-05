defmodule RepartoWeb.RouteController do
  use RepartoWeb, :controller

  alias Reparto.Coverage
  alias Reparto.Coverage.Route

  def index(conn, _params) do
    %{current_company: current_company} = conn.assigns
    routes = Coverage.list_routes(current_company)
    render(conn, :index, routes: routes)
  end

  def new(conn, _params) do
    changeset = Coverage.change_route(%Route{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"route" => route_params}) do
    %{current_company: current_company} = conn.assigns
    %{"points_text" => points_text} = route_params
    route_params = Map.delete(route_params, "points_text")
    decoded_points = Jason.decode!(points_text) |> Geo.JSON.decode!
    route_params = Map.put(route_params, "points", decoded_points)
    case Coverage.create_route(route_params, current_company) do
      {:ok, route} ->
        conn
        |> put_flash(:info, "Route created successfully.")
        |> redirect(to: ~p"/companies/#{current_company}/routes/#{route}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    route = Coverage.get_route!(id)
    %{points: points} = route
    geojson_string = Geo.JSON.encode!(points) |> Jason.encode!
    render(conn, :show, route: route, geojson_string: geojson_string)
  end

  def edit(conn, %{"id" => id}) do
    route = Coverage.get_route!(id)
    changeset = Coverage.change_route(route)
    render(conn, :edit, route: route, changeset: changeset)
  end

  def update(conn, %{"id" => id, "route" => route_params}) do
    route = Coverage.get_route!(id)
    %{current_company: current_company} = conn.assigns

    case Coverage.update_route(route, route_params) do
      {:ok, route} ->
        conn
        |> put_flash(:info, "Route updated successfully.")
        |> redirect(to: ~p"/companies/#{current_company}/routes/#{route}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, route: route, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    route = Coverage.get_route!(id)
    %{current_company: current_company} = conn.assigns
    {:ok, _route} = Coverage.delete_route(route)

    conn
    |> put_flash(:info, "Route deleted successfully.")
    |> redirect(to: ~p"/companies/#{current_company}/routes")
  end
end
