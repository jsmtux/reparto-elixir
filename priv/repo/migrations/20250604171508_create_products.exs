defmodule Reparto.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :image, :string
      add :price, :float
      add :company_id, references(:companies, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:company_id])
  end
end
