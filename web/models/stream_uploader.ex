defmodule Streamr.StreamUploader do
  alias Streamr.Repo

  def process(stream) do
    file_name = file_name_for(stream)
    create_file(file_name)

    Postgrex.transaction(pg_link_pid, fn(conn) ->
      conn
      |> Postgrex.stream(io_query(conn, stream), [])
      |> Enum.into(File.stream!(file_name), pg_result_to_io)
    end)
  end

  defp stream_data_query(stream) do
    """
      select line
      from stream_data
      left join lateral unnest(lines) as line on true
      where stream_id = #{stream.id}
      order by line->>'time' asc
    """
  end

  defp file_name_for(stream) do
    "stream_upload_data_#{stream.id}"
  end

  defp pg_link_pid do
    repo_config
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
    fn(%Postgrex.Result{rows: rows}) -> rows end
  end

  defp io_query(conn, stream) do
    Postgrex.prepare!(conn, "", "COPY (#{stream_data_query(stream)}) TO STDOUT")
  end
end
