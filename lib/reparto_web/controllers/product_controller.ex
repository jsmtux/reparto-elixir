defmodule RepartoWeb.ProductController do
  use RepartoWeb, :controller

  alias Reparto.Directory
  alias Reparto.Catalog
  alias Reparto.Catalog.Product

  plug :put_company

  defp put_company(conn, _opts) do
    current_company = Directory.get_company!(conn.params["company_id"])
    assign(conn, :current_company, current_company)
  end

  def index(conn, _params) do
    %{current_company: current_company} = conn.assigns
    products = Catalog.list_products(current_company)
    render(conn, :index, products: products)
  end

  def new(conn, _params) do
    changeset = Catalog.change_product(%Product{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    %{current_company: current_company} = conn.assigns
    case Catalog.create_product(product_params, current_company) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: ~p"/companies/#{current_company}/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    changeset = Catalog.change_product(product)
    render(conn, :edit, product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Catalog.get_product!(id)
    %{current_company: current_company} = conn.assigns

    case Catalog.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: ~p"/companies/#{current_company}/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    %{current_company: current_company} = conn.assigns
    product = Catalog.get_product!(id)
    {:ok, _product} = Catalog.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: ~p"/companies/#{current_company}/products")
  end
end
