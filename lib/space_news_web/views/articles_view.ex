defmodule SpaceNewsWeb.ArticlesView do
  use SpaceNewsWeb, :view

  def format_article_date(date) do
    date
    |> Timex.parse!("{ISO:Extended}")
    |> Timex.format!("{0D}/{0M}/{YYYY}")
  end

  def previous_page_number(1), do: 1
  def previous_page_number(current_page), do: current_page - 1

  def next_page_number(current_page, total_pages) when current_page == total_pages,
    do: total_pages

  def next_page_number(current_page, _total_pages), do: current_page + 1
end
