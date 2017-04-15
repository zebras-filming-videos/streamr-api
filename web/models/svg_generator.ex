defmodule Streamr.SVGGenerator do
  import Ecto.Query

  alias Streamr.{Repo, StreamData, Color}

  import IEx

  def generate(stream) do
    filepath = "foo.svg"
    create_file(stream, filepath)
    color_map = Repo.all(from c in Color, select: {c.id, c.normal}) |> Enum.into(%{})

    Postgrex.transaction(pg_link_pid(), fn(conn) ->
      conn
      |> Postgrex.stream(io_query(conn, stream), [])
      |> Enum.into(File.stream!(filepath, [:append]), pg_result_to_io(color_map))
    end)

    File.write!(filepath, svg_footer(), [:append])
  end

  defp create_file(stream, filepath) do
    File.touch(filepath)
    File.write!(filepath, svg_header())
  end

  defp pg_link_pid do
    repo_config()
    |> Postgrex.start_link()
    |> elem(1)
  end

  defp repo_config do
    Application.get_env(:streamr, Repo)
  end

  defp create_file(name) do
    File.touch(name)
  end

  defp pg_result_to_io(color_map) do
    fn %Postgrex.Result{rows: rows} ->
      Enum.map rows, fn row ->
        decoded_row = Poison.decode!(row)

        color = Map.get(color_map, String.to_integer(decoded_row["color_id"]))
        width = Map.get(decoded_row, "thickness")

        path = decoded_row
        |> Map.get("points")
        |> Enum.map(fn point -> "#{point["x"] * 1920},#{point["y"] * 1080}" end)
        |> Enum.join("L")

        ~s(<path stroke="#{color}" stroke-width="#{width}" d="M#{path}"></path>)
      end
    end
  end

  defp io_query(conn, stream) do
    Postgrex.prepare!(conn, "", "copy (#{stream_data_query(stream)}) to stdout")
  end

  def stream_data_query(stream) do
    """
      select line
      from stream_data
      left join lateral unnest(lines) as line on true
      where stream_id = #{stream.id}
      order by line->>'time' asc
    """
  end

  defp svg_header do
    ~s(
      <svg viewBox="0 0 1920 1080"><g fill="none">
        <rect x="0" y="0" width="1920" height="1080" fill="#000000"></rect>
    )
  end

  defp svg_footer do
    "</g></svg>"
  end
end
