defmodule SpaceNews.Paginator do
  @moduledoc """
  Paginate your Ecto queries.
  Instead of using: `Repo.all(query)`, you can use: `Paginator.page(query)`.
  To change the page you can pass the page number as the second argument.
  ## Examples
      iex> Paginator.paginate(query, 1)
      [%Item{id: 1}, %Item{id: 2}, %Item{id: 3}, %Item{id: 4}, %Item{id: 5}]
      iex> Paginator.paginate(query, 2)
      [%Item{id: 6}, %Item{id: 7}, %Item{id: 8}, %Item{id: 9}, %Item{id: 10}]
  """

  import Ecto.Query
  alias SpaceNews.Repo

  @results_per_page 5

  def paginate(query, page, preload) when is_nil(page) do
    paginate(query, 1, preload)
  end

  def paginate(query, page, preload) when is_binary(page) do
    paginate(query, String.to_integer(page), preload)
  end

  def paginate(query, page, preload) do
    results = execute_query(query, page, preload)
    total_results = count_total_results(query)
    total_pages = count_total_pages(total_results)

    %{
      current_page: page,
      results_per_page: @results_per_page,
      total_pages: total_pages,
      total_results: total_results,
      results: results
    }
  end

  defp execute_query(query, page, preload) when not is_nil(preload) do
    query
    |> limit(^@results_per_page)
    |> offset((^page - 1) * ^@results_per_page)
    |> Repo.all()
    |> Repo.preload(preload)
  end

  defp execute_query(query, page, _) do
    query
    |> limit(^@results_per_page)
    |> offset((^page - 1) * ^@results_per_page)
    |> Repo.all()
  end

  defp count_total_results(query) do
    Repo.aggregate(query, :count, :id)
  end

  defp count_total_pages(total_results) do
    total_pages = ceil(total_results / @results_per_page)

    if total_pages > 0, do: total_pages, else: 1
  end
end
