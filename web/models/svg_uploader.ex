defmodule Streamr.SVGUploader do
  alias Streamr.{SVGGenerator, S3Service}

  def upload(stream) do
    stream
    |> SVGGenerator.generate()
    |> upload_files(stream)
  end

  defp upload_files(filepaths_map, stream) do
    Enum.reduce filepaths_map, %{}, fn {palette, filepath}, map ->
      Map.put(map, palette, S3Service.upload_file(filepath, stream))
    end
  end
end
