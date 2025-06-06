defmodule RepartoWeb.Router do
  use RepartoWeb, :router

  import RepartoWeb.UserAuth

  alias RepartoWeb.RouteController
  alias RepartoWeb.ProductController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RepartoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
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
    get "/show_delivery/:company_id/:route_id", DeliveryQueryController, :show
  end

  scope "/", RepartoWeb do
    pipe_through [:browser, :require_authenticated_user]
    resources "/companies", CompanyController
  end

  scope "/companies/:company_id" do
    pipe_through [:browser, :put_company, :require_authenticated_user]
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

  ## Authentication routes

  scope "/", RepartoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{RepartoWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", RepartoWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{RepartoWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
