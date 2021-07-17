defmodule RenaissanceText do
  # Unicode code point for Paragraph Separator
  def utf_ps() do "\u2029" end

  @spec unicodify_newlines(binary) :: binary
  def unicodify_newlines(nil) do nil end
  def unicodify_newlines(str) do
    Regex.replace(~r/[\r\n]+/, str, utf_ps())
  end

  def newlineify_unicode (nil) do nil end
  def newlineify_unicode (str) do
    String.replace(str, utf_ps(), "\n\n")
  end
end
