defmodule RepartoWeb.CompanyController do
  use RepartoWeb, :controller

  alias Reparto.Directory
  alias Reparto.Directory.Company

  def index(conn, _params) do
    companies = Directory.list_companies()
    render(conn, :index, companies: companies)
  end

  def new(conn, _params) do
    changeset = Directory.change_company(%Company{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    case Directory.create_company(company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Directory.get_company!(id)
    render(conn, :show, company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Directory.get_company!(id)
    changeset = Directory.change_company(company)
    render(conn, :edit, company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Directory.get_company!(id)

    case Directory.update_company(company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: ~p"/companies/#{company}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Directory.get_company!(id)
    {:ok, _company} = Directory.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: ~p"/companies")
  end
end
