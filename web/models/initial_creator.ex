defmodule Streamr.InitialCreator do
  @size 512
  @resolution 72
  @sampling_factor 3
  @density @resolution * @sampling_factor

  import IEx

  def process(user) do
    size = 512
    resolution = 72
    sampling_factor = 3
    initials = user.name |> String.split(" ") |> format_initials()

    System.cmd "convert", [
      "-density", "#{resolution * sampling_factor}",                # sample up
      "-size", "#{size*sampling_factor}x#{size*sampling_factor}",   # corrected size
      "canvas:##{background_color(user)}",
      "-fill", user |> background_color |> text_color,                                           # text color
      "-font", "/Library/Fonts/Roboto-Bold.ttf",                    # font location
      "-pointsize", "300",                                          # font size
      "-gravity", "center",                                         # center text
      "-annotate", "+0+#{25 * sampling_factor}", initials,          # render text, move down a bit
      "-resample", "#{resolution}",                                 # sample down to reduce aliasing
      "#{user.id}.png"
    ]
  end

  defp size do
    "#{@density}x#{@density}"
  end

  defp background_color(user) do
    :sha256
    |> :crypto.hash(user.name)
    |> Base.encode16()
    |> String.slice(0..5)
  end

  defp text_color(background_color) do
    [red, green, blue] =
      background_color
      |> String.graphemes()
      |> Enum.chunk(2)
      |> Enum.map(fn(chunk) -> String.to_integer(Enum.join(chunk), 16) end)

    result = (red * 299 + green * 587 + blue * 114) / 1000

    if (result > 125), do: "#000000", else: "#ffffff"
  end

  defp format_initials(names) do
    names
    |> limit_names()
    |> Enum.reduce("", fn(name, initials) -> initials <> String.first(name) end)
  end

  defp limit_names([first_name]), do: [first_name]
  defp limit_names([first_name | other_names]), do: [first_name, List.last(other_names)]
end
