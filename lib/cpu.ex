defmodule CPUEntity do
  @type t() :: %__MODULE__{
          id: ID.t(),
          cpu_specifications: map(),
          # Note, simple String.t() will also work
          hash: String.t()
        }

  defstruct [
    :id,
    :cpu_specifications,
    :hash
  ]

  @spec new(ID.t(), map(), HashVO.t()) :: t()
  def new(id, cpu_specifications, hash) do
    %__MODULE__{
      id: id,
      cpu_specifications: cpu_specifications,
      hash: hash
    }
  end

  def run() do
    id = 32
    cpu_specifications = %{}
    hash = HashVO.new("c7a9f84bb5ac28e434238294999c298637e77cce")

    new(id, cpu_specifications, hash)
  end
end

defmodule ID do
  @type t() :: non_neg_integer()
end

defmodule HashVO do
  @opaque t() :: String.t()

  def new(hash) do
    # your code
    hash
  end
end
