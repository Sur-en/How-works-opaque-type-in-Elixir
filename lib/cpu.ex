defmodule CPUEntity do
  @type t() :: %__MODULE__{
          id: ID.t(),
          cpu_specifications: CPUSpecificationsVO.t(),
          # Note, simple String.t() will also work
          hash: String.t()
        }

  defstruct [
    :id,
    :cpu_specifications,
    :hash
  ]

  @spec new(ID.t(), CPUSpecificationsVO.t(), HashVO.t()) :: t()
  def new(id, cpu_specifications, hash) do
    %__MODULE__{
      id: id,
      cpu_specifications: cpu_specifications,
      hash: hash
    }
  end

  def run() do
    id = 32
    cpu_specifications = CPUSpecificationsVO.new("i3", 4)
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

defmodule CPUSpecificationsVO do
  @opaque t() :: %__MODULE__{
            version: String.t(),
            core_count: non_neg_integer()
          }

  defstruct [:version, :core_count]

  def new(version, core_count) do
    %__MODULE__{version: version, core_count: core_count}
  end
end
