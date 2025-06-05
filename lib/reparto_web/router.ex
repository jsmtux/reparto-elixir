defmodule RepartoWeb.Router do
  use RepartoWeb, :router

  alias RepartoWeb.RouteController
  alias RepartoWeb.ProductController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RepartoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :under_company do
    plug :put_company
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RepartoWeb do
    pipe_through :browser

    get "/", HomeController, :index
    post "/delivery_query", DeliveryQueryController, :create
    resources "/companies", CompanyController
  end

  scope "/companies/:company_id" do
    pipe_through :browser
    pipe_through :put_company
    resources "/products", ProductController
    resources "/routes", RouteController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RepartoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:reparto, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RepartoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp put_company(conn, _opts) do
    alias Reparto.Directory
    current_company = Directory.get_company!(conn.params["company_id"])
    assign(conn, :current_company, current_company)
  end
end
