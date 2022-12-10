defmodule TodolistApi.Mails.ForgetPasswordMail do
  import Swoosh.Email

  def verify_code(email,code) do
    new()
    |> to(email)
    |> from({"Todolist", "todolist.app@tdlst.com"})
    |> subject("Forget Password Verify Code")
    |> html_body("Your code is <b>#{code}</b>")
  end
end
