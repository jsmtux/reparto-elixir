defmodule RepartoWeb.RouteControllerTest do
  use RepartoWeb.ConnCase

  import Reparto.CoverageFixtures

  @create_attrs %{day_of_week: 42}
  @update_attrs %{day_of_week: 43}
  @invalid_attrs %{day_of_week: nil}

  describe "index" do
    test "lists all routes", %{conn: conn} do
      conn = get(conn, ~p"/routes")
      assert html_response(conn, 200) =~ "Listing Routes"
    end
  end

  describe "new route" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/routes/new")
      assert html_response(conn, 200) =~ "New Route"
    end
  end

  describe "create route" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/routes", route: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/routes/#{id}"

      conn = get(conn, ~p"/routes/#{id}")
      assert html_response(conn, 200) =~ "Route #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/routes", route: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Route"
    end
  end

  describe "edit route" do
    setup [:create_route]

    test "renders form for editing chosen route", %{conn: conn, route: route} do
      conn = get(conn, ~p"/routes/#{route}/edit")
      assert html_response(conn, 200) =~ "Edit Route"
    end
  end

  describe "update route" do
    setup [:create_route]

    test "redirects when data is valid", %{conn: conn, route: route} do
      conn = put(conn, ~p"/routes/#{route}", route: @update_attrs)
      assert redirected_to(conn) == ~p"/routes/#{route}"

      conn = get(conn, ~p"/routes/#{route}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, route: route} do
      conn = put(conn, ~p"/routes/#{route}", route: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Route"
    end
  end

  describe "delete route" do
    setup [:create_route]

    test "deletes chosen route", %{conn: conn, route: route} do
      conn = delete(conn, ~p"/routes/#{route}")
      assert redirected_to(conn) == ~p"/routes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/routes/#{route}")
      end
    end
  end

  defp create_route(_) do
    route = route_fixture()

    %{route: route}
  end
end
