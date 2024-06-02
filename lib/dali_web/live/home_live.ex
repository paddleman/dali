defmodule DaliWeb.HomeLive do
  use DaliWeb, :live_view

  def mount(_params, _session, socket) do


    {:ok, socket}

  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center text-red-500">Home Live </h1>
    """

  end


end
