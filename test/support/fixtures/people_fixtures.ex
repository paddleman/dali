defmodule Dali.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dali.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Dali.People.create_person()

    person
  end
end
