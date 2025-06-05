defmodule Reparto.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Reparto.Directory` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image: "some image",
        name: "some name"
      })
      |> Reparto.Directory.create_company()

    company
  end
end
