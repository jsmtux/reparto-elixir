defmodule Reparto.Coverage.Route do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reparto.Directory.Company

  schema "routes" do
    field :day_of_week, :integer
    field :points, Geo.PostGIS.Geometry
    belongs_to :company, Company

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [:day_of_week, :points])
    |> validate_required([:day_of_week])
    |> validate_inclusion(:day_of_week, 1..7)
    |> foreign_key_constraint(:company_id)
  end
end
