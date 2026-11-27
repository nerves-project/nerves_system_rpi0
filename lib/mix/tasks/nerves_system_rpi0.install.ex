# SPDX-FileCopyrightText: 2026 Lars Wikman
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule Mix.Tasks.NervesSystemRpi0.Install.Docs do
  @moduledoc false

  @app :nerves_system_rpi0
  @target :rpi0

  # The requirement that's written to the user's mix.exs follows this system's
  # version so that it doesn't need to be updated for releases. Prereleases
  # are only matched by requirements that have a prerelease part.
  @external_resource Path.expand("../../../VERSION", __DIR__)
  @requirement (case Version.parse!(Mix.Project.config()[:version]) do
                  %Version{pre: []} = v -> "~> #{v.major}.#{v.minor}"
                  v -> "~> #{v}"
                end)

  @spec app() :: atom()
  def app(), do: @app

  @spec target() :: atom()
  def target(), do: @target

  @spec requirement() :: String.t()
  def requirement(), do: @requirement

  @spec dependency() :: String.t()
  def dependency() do
    "{#{inspect(@app)}, #{inspect(@requirement)}, runtime: false, targets: #{inspect(@target)}}"
  end

  @spec short_doc() :: String.t()
  def short_doc() do
    "Adds the #{@target} target to a Nerves project"
  end

  @spec example() :: String.t()
  def example() do
    "mix igniter.install #{@app}"
  end

  @spec long_doc() :: String.t()
  def long_doc() do
    """
    #{short_doc()}

    This lets an existing Nerves project build firmware for the `#{@target}`
    target by adding `#{inspect(@app)}` to it.

    ## Example

    ```bash
    #{example()}
    ```

    ## What it does

    * Makes sure that the `mix.exs` dependencies have

      ```elixir
      #{dependency()}
      ```

      If `#{inspect(@app)}` is already a dependency, its version requirement
      or source is kept, `runtime: false` is set and `#{inspect(@target)}` is added
      to any targets that it already has.
    * Adds `#{inspect(@target)}` to the `@all_targets` module attribute if `mix.exs`
      has one

    Running it again doesn't change anything.

    Afterwards, build firmware by running:

    ```bash
    export MIX_TARGET=#{@target}
    mix deps.get
    mix firmware
    ```

    This requires Nerves 2.0 or later. To turn a project that doesn't use
    Nerves yet into a Nerves project for this target, run `mix igniter.install
    nerves --target #{@target}` instead.
    """
  end
end

if Code.ensure_loaded?(Igniter) and Code.ensure_loaded?(Nerves.Igniter) do
  defmodule Mix.Tasks.NervesSystemRpi0.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :nerves,
        example: __MODULE__.Docs.example()
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      docs = __MODULE__.Docs

      igniter
      |> Nerves.Igniter.add_system(docs.app(), docs.target(), requirement: docs.requirement())
      |> add_non_nerves_notice()
    end

    defp add_non_nerves_notice(igniter) do
      if Nerves.Igniter.nerves_project?(igniter) do
        igniter
      else
        docs = __MODULE__.Docs

        Igniter.add_notice(igniter, """
        #{docs.app()}: this doesn't look like a Nerves project. The system
        was added to mix.exs, but it can't be used until the project is set up
        for Nerves. To do that, run:

            mix igniter.install nerves --target #{docs.target()}
        """)
      end
    end
  end
else
  defmodule Mix.Tasks.NervesSystemRpi0.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` and Nerves 2 to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task '#{__MODULE__.Docs.app()}.install' #{String.trim_trailing(reason())}

      Alternatively, update the dependency in your mix.exs by hand:

          #{__MODULE__.Docs.dependency()}
      """)

      exit({:shutdown, 1})
    end

    # This module is compiled when igniter or its support in Nerves is missing.
    # Check again to report what's missing now.
    defp reason() do
      cond do
        not Code.ensure_loaded?(Igniter) ->
          """
          requires igniter. Please install igniter and try again.

          For more information, see: https://igniter.hexdocs.pm/readme.html#installation
          """

        not Code.ensure_loaded?(Nerves.Igniter) ->
          """
          requires the Igniter support in Nerves 2.0 or later (`Nerves.Igniter`).

          This project uses #{nerves_version()}, which doesn't have it. See
          https://nerves.hexdocs.pm/updating-projects.html for how to update.
          """

        true ->
          """
          wasn't available when #{__MODULE__.Docs.app()} was compiled.
          Recompile it and try again:

              mix deps.compile #{__MODULE__.Docs.app()} --force
          """
      end
    end

    defp nerves_version() do
      _ = Application.load(:nerves)

      case Application.spec(:nerves, :vsn) do
        nil -> "a version of Nerves"
        vsn -> "Nerves #{vsn}"
      end
    end
  end
end
