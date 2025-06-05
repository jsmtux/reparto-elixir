defmodule RepartoWeb.RouteHTML do
  use RepartoWeb, :html

  embed_templates "route_html/*"

  @doc """
  Renders a route form.

  The form is defined in the template at
  route_html/route_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def route_form(assigns)
end
