defmodule RenaissanceText do
  # Unicode code point for Paragraph Separator
  def utf_ps(), do: "\u2029"

  @spec unicodify_newlines(binary) :: binary
  def unicodify_newlines(nil), do: nil
  def unicodify_newlines(str), do: Regex.replace(~r/[\r\n]+/, str, utf_ps())

  def newlineify_unicode(nil), do: nil
  def newlineify_unicode(str), do: String.replace(str, utf_ps(), "\n\n")
end
