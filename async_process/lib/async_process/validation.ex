defmodule AsyncProcess.Validation do
  @items [1,2,3,4,5,6,7,8,9]
  def create_payload() do
    order_items = create_order_items(@items)
    %{
      "processed" => :ok,
      "items" => order_items
    }
  end

  def create_payload_async do
    order_items = create_order_items_async(@items)
    %{
      "processed" => :ok,
      "items" => order_items
    }
  end

  defp create_order_items_async(items) do
    stream = Task.Supervisor.async_stream(Validation.TaskSupervisor, items, fn item -> create_item(item) end)
    Enum.map(stream, fn item ->
      if match?({:ok, _}, item) do
        {:ok, transformed} = item
        transformed
      end
    end)
  end

  defp create_order_items(items) do
    Enum.map(items, fn item -> create_item(item) end)
  end

  defp create_item(item) do
    item_title = get_item(item)
    %{
      "id" => item,
      "title" => item_title
    }
  end

  defp get_item(item) do
    rand = :rand.uniform(3)
    :timer.sleep(rand * 1000)
    "Item #{item} waited #{rand} secs"
  end
end
