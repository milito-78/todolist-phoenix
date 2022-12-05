defmodule TodolistApi.ForgetPasswords.ForgetPassword do
  alias TodolistApi.ForgetPasswords
  alias TodolistApi.ForgetPasswords.ForgetPassword

  defstruct [:uuid, :email, :token, :code , :timestamps, :expire]

  @spec encode(ForgetPassword) :: String.t
  def encode(data) do
    "#{data.email}-#{data.code}-#{data.timestamps}"
  end

  @spec toMap(ForgetPassword) :: map()
  def toMap(data) do
    %{email: data.email,code: data.code, timestamps: data.timestamps}
  end

  @spec decode(String.t) :: {:ok, ForgetPassword} | {:error,:invalid_structure} | {:error,:empty}
  def decode(data) do
    spl = String.split(data, "-")
    |> decoding()
  end

  defp decoding([]), do: {:error,:empty}
  defp decoding([email, code, timestamps]) do
    {int_time, _} = Integer.parse(timestamps)

    {
      :ok,
      %ForgetPassword{
        email: email,
        code: code,
        timestamps: timestamps,
        expire: DateTime.diff(
          Timex.from_unix(int_time,:second),
          DateTime.utc_now(),
          :second
        )
      }
    }
  end
  defp decoding(_param), do: {:error,:invalid_structure}



  def store(key,data) do

  end

  def get(key) do

  end


end
