defmodule Reparto.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :description, :string
      add :image, :string

      timestamps(type: :utc_datetime)
    end
  end
end
