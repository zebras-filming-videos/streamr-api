# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Streamr.Repo.insert!(%Streamr.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Streamr.{Repo, Topic, Stream, Color, StreamData, Comment, Vote}

defmodule SeedHelpers do
  def aws_url(path) do
    "https://s3-us-west-2.amazonaws.com/streamr-staging/Seeds/" <> path
  end
end

Repo.delete_all Topic
Repo.insert! %Topic{name: "Art History"}
Repo.insert! %Topic{name: "Biology"}
Repo.insert! %Topic{name: "Chemistry"}
Repo.insert! %Topic{name: "Computer Science"}
Repo.insert! %Topic{name: "Cosmology & Astronomy"}
Repo.insert! %Topic{name: "Electrical Engineering"}
Repo.insert! %Topic{name: "Entrepreneurship"}
Repo.insert! %Topic{name: "Grammar"}
Repo.insert! %Topic{name: "Health & Medicine"}
Repo.insert! %Topic{name: "Macroeconomics"}
Repo.insert! %Topic{name: "Microeconomics"}
Repo.insert! %Topic{name: "Music"}
Repo.insert! %Topic{name: "Organic Chemistry"}
Repo.insert! %Topic{name: "Physics"}
Repo.insert! %Topic{name: "US History"}
Repo.insert! %Topic{name: "World History"}

Repo.delete_all Vote
Repo.delete_all Comment
Repo.delete_all StreamData
Repo.delete_all Stream

normal_colors = %{
  red: "#e06c75",
  blue: "#61afef",
  green: "#98c379",
  orange: "#d19a66",
  purple: "#c678dd",
  white: "#abb2bf",
}

protanopia_colors = %{
  # red: "#7c08ff",
  red: "#9c4bf9",
  blue: "#61afef",
  green: "#9b9fa2",
  orange: "#d19a66",
  purple: "#b940dd",
  white: "#ffffff",
}

deuteranopia_colors = %{}

tritanopia_colors = %{}

color_orders = [
  {:white, 1},
  {:red, 2},
  {:orange, 3},
  {:green, 4},
  {:blue, 5},
  {:purple, 6}
]

Enum.each color_orders, fn {color, order} ->
  changes = %{
    normal: normal_colors[color],
    protanopia: protanopia_colors[color],
    deuteranopia: deuteranopia_colors[color],
    tritanopia: tritanopia_colors[color],
    order: order
  }

  Color
  |> Repo.get_by(order: order)
  |> Kernel.||(%Color{})
  |> Color.changeset(changes)
  |> Repo.insert_or_update()
end
