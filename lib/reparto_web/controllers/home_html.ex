defmodule RepartoWeb.HomeHTML do
  use RepartoWeb, :html

  embed_templates "home_html/*"

  @doc """
  Renders a product form.

  The form is defined in the template at
  product_html/product_form.html.heex
  """
  attr :coords, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def coord_form(assigns)
end
