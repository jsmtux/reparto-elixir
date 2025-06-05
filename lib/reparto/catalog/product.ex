defmodule Reparto.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reparto.Directory.Company

  schema "products" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :price, :float
    belongs_to :company, Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :image, :price])
    |> validate_required([:name, :description, :image, :price])
    |> foreign_key_constraint(:company_id)
  end
end
