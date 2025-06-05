defmodule Reparto.CoverageTest do
  use Reparto.DataCase

  alias Reparto.Coverage

  describe "routes" do
    alias Reparto.Coverage.Route

    import Reparto.CoverageFixtures

    @invalid_attrs %{day_of_week: nil}

    test "list_routes/0 returns all routes" do
      route = route_fixture()
      assert Coverage.list_routes() == [route]
    end

    test "get_route!/1 returns the route with given id" do
      route = route_fixture()
      assert Coverage.get_route!(route.id) == route
    end

    test "create_route/1 with valid data creates a route" do
      valid_attrs = %{day_of_week: 42}

      assert {:ok, %Route{} = route} = Coverage.create_route(valid_attrs)
      assert route.day_of_week == 42
    end

    test "create_route/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Coverage.create_route(@invalid_attrs)
    end

    test "update_route/2 with valid data updates the route" do
      route = route_fixture()
      update_attrs = %{day_of_week: 43}

      assert {:ok, %Route{} = route} = Coverage.update_route(route, update_attrs)
      assert route.day_of_week == 43
    end

    test "update_route/2 with invalid data returns error changeset" do
      route = route_fixture()
      assert {:error, %Ecto.Changeset{}} = Coverage.update_route(route, @invalid_attrs)
      assert route == Coverage.get_route!(route.id)
    end

    test "delete_route/1 deletes the route" do
      route = route_fixture()
      assert {:ok, %Route{}} = Coverage.delete_route(route)
      assert_raise Ecto.NoResultsError, fn -> Coverage.get_route!(route.id) end
    end

    test "change_route/1 returns a route changeset" do
      route = route_fixture()
      assert %Ecto.Changeset{} = Coverage.change_route(route)
    end
  end
end
