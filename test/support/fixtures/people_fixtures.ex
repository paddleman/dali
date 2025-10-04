defmodule Dali.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dali.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        first_name: "some first_name",
        last_name: "some last_name"
      })

    {:ok, person} = Dali.People.create_person(scope, attrs)
    person
  end
end
