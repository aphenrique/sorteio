defmodule SorteioWeb.Router do
  use SorteioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SorteioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SorteioWeb do
    pipe_through :browser

    get "/", UserController, :new

    live "/rooms/new", RoomLive.Index, :new
    # live "/rooms/:id/edit", RoomLive.Index, :edit

    live "/rooms/:id", RoomLive.Show, :show
    # live "/rooms/:id/show/edit", RoomLive.Show, :edit

    resources "/users", UserController

    live "/prizes", PrizeLive.Index, :index
    live "/prizes/new", PrizeLive.Index, :new
    live "/prizes/:id/edit", PrizeLive.Index, :edit

    live "/prizes/:id", PrizeLive.Show, :show
    live "/prizes/:id/show/edit", PrizeLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", SorteioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sorteio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SorteioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
