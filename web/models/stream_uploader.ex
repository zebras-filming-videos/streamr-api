defmodule Streamr.StreamUploader do
  alias Streamr.{Repo, S3Service}
  alias Ecto.Adapters.SQL

  import IEx

  def process(stream) do
    stream
    |> write_to_file
    |> S3Service.upload_file(stream)
  end

  defp write_to_file(stream) do
    file_name = file_name_for(stream)
    create_file(file_name)

    data = Repo
    |> SQL.query!(stream_data_query(stream))
    |> Map.get(:rows)
    |> Enum.into(File.stream!(file_name), pg_result_to_io())

    file_name
  end

  defp stream_data_query(stream) do
    """
      select line
      from stream_data
      left join lateral unnest(lines) as line on true
      where stream_id = #{stream.id}
      order by (line->>'time')::int asc
    """
   end

  defp file_name_for(stream) do
    "uploads/stream_upload_data_#{stream.id}"
  end

  defp pg_link_pid do
    repo_config()
    |> Postgrex.start_link
    |> elem(1)
  end

  defp repo_config do
    Application.get_env(:streamr, Repo)
  end

  defp create_file(name) do
    File.touch(name)
  end

  defp pg_result_to_io do
    fn [line] -> Poison.encode!(line) <> "\n" end
  end

  defp io_query(conn, stream) do
    Postgrex.prepare!(conn, "", "copy (#{stream_data_query(stream)}) to stdout")
  end
end
