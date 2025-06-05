defmodule RepartoWeb.CompanyHTML do
  use RepartoWeb, :html

  embed_templates "company_html/*"

  @doc """
  Renders a company form.

  The form is defined in the template at
  company_html/company_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def company_form(assigns)
end
