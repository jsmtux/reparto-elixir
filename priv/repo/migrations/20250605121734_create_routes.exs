defmodule Reparto.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  def change do
    create table(:routes) do
      add :day_of_week, :integer
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    execute("SELECT AddGeometryColumn ('routes','points',4326,'LINESTRING',2);", "")
    execute("CREATE INDEX test_geom_idx ON routes USING GIST (points);", "")

    create index(:routes, [:company_id])
  end
end
