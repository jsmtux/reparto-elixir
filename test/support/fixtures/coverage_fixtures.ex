defmodule Reparto.CoverageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Reparto.Coverage` context.
  """

  @doc """
  Generate a route.
  """
  def route_fixture(attrs \\ %{}) do
    {:ok, route} =
      attrs
      |> Enum.into(%{
        day_of_week: 42
      })
      |> Reparto.Coverage.create_route()

    route
  end
end
