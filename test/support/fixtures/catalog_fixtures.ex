defmodule Reparto.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Reparto.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "some image",
        name: "some name",
        price: 120.5
      })
      |> Reparto.Catalog.create_product()

    product
  end
end
