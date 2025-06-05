defmodule Reparto.DirectoryTest do
  use Reparto.DataCase

  alias Reparto.Directory

  describe "companies" do
    alias Reparto.Directory.Company

    import Reparto.DirectoryFixtures

    @invalid_attrs %{name: nil, description: nil, image: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Directory.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Directory.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", description: "some description", image: "some image"}

      assert {:ok, %Company{} = company} = Directory.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.description == "some description"
      assert company.image == "some image"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", image: "some updated image"}

      assert {:ok, %Company{} = company} = Directory.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.description == "some updated description"
      assert company.image == "some updated image"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_company(company, @invalid_attrs)
      assert company == Directory.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Directory.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Directory.change_company(company)
    end
  end
end
