# SPDX-FileCopyrightText: 2026 Lars Wikman
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule Mix.Tasks.NervesSystemRpi0.InstallTest do
  use ExUnit.Case, async: true

  @app :nerves_system_rpi0
  @target :rpi0
  @task "#{@app}.install"

  # The installer needs igniter and a version of Nerves that has
  # `Nerves.Igniter` (2.0 or later). Without them, the task is a stub that
  # says what's missing.
  if Code.ensure_loaded?(Igniter) and Code.ensure_loaded?(Nerves.Igniter) do
    import Igniter.Test

    # What `mix nerves.new` and `mix igniter.install nerves` create
    defp nerves_project(deps, attributes \\ "") do
      test_project(
        files: %{
          "mix.exs" => """
          defmodule Test.MixProject do
            use Mix.Project

            @app :test
            @version "0.1.0"
          #{attributes}
            def project do
              [
                app: @app,
                version: @version,
                archives: [nerves_bootstrap: "~> 1.17"],
                deps: deps()
              ]
            end

            defp deps do
              [
                {:nerves, "~> 2.0", runtime: false},
                {:nerves_runtime, "~> 0.13.12"}#{Enum.map(deps, &",\n      #{&1}")}
              ]
            end
          end
          """,
          "config/target.exs" => "import Config\n"
        }
      )
    end

    defp install(igniter), do: Igniter.compose_task(igniter, @task, [])

    defp mix_exs(igniter) do
      igniter.rewrite |> Rewrite.source!("mix.exs") |> Rewrite.Source.get(:content)
    end

    # Returns a dependency the way that it's written in the mix.exs
    defp dep(igniter, app \\ @app) do
      {:ok, declaration} = Igniter.Project.Deps.get_dep(igniter, app)
      {dep, _binding} = Code.eval_string(declaration)
      dep
    end

    defp requirement() do
      case Version.parse!(Mix.Project.config()[:version]) do
        %Version{pre: []} = v -> "~> #{v.major}.#{v.minor}"
        v -> "~> #{v}"
      end
    end

    test "adds the system for its target" do
      igniter = nerves_project([]) |> install()

      assert dep(igniter) == {@app, requirement(), runtime: false, targets: @target}
      assert Nerves.Igniter.project_targets(igniter) == [@target]
    end

    test "derives the requirement from this system's version" do
      assert Mix.Tasks.NervesSystemRpi0.Install.Docs.requirement() == requirement()
      assert Version.match?(Mix.Project.config()[:version], requirement())
    end

    test "uses the same target as `mix nerves.install --target #{@target}`" do
      assert {:ok, {@app, _requirement}} = Nerves.Igniter.system_for_target(@target)
    end

    test "keeps other systems and their targets" do
      other = ~s|{:nerves_system_other, "~> 1.0", runtime: false, targets: :other}|

      igniter = nerves_project([other]) |> install() |> apply_igniter!()

      assert mix_exs(igniter) =~ other
      assert dep(igniter) == {@app, requirement(), runtime: false, targets: @target}
      assert Nerves.Igniter.project_targets(igniter) == [:other, @target]
    end

    test "fixes up the bare dependency that `mix igniter.install` adds" do
      igniter = nerves_project([~s|{#{inspect(@app)}, "~> 0.1"}|]) |> install()

      assert dep(igniter) == {@app, "~> 0.1", runtime: false, targets: @target}
    end

    test "keeps the source of an existing dependency" do
      igniter = nerves_project([~s|{#{inspect(@app)}, path: "../#{@app}"}|]) |> install()

      assert dep(igniter) == {@app, path: "../#{@app}", runtime: false, targets: @target}
    end

    test "appends its target to the targets that the dependency already has" do
      one_target =
        nerves_project([~s|{#{inspect(@app)}, "~> 0.1", runtime: false, targets: :my_board}|])
        |> install()

      assert dep(one_target) == {@app, "~> 0.1", runtime: false, targets: [:my_board, @target]}

      many_targets =
        nerves_project([
          ~s|{#{inspect(@app)}, "~> 0.1", runtime: false, targets: [:my_board, :my_other_board]}|
        ])
        |> install()

      assert dep(many_targets) ==
               {@app, "~> 0.1", runtime: false, targets: [:my_board, :my_other_board, @target]}
    end

    test "adds its target to @all_targets" do
      igniter =
        nerves_project(
          [~s|{:nerves_pack, "~> 0.7", targets: @all_targets}|],
          "  @all_targets [:other, :my_board]\n"
        )
        |> install()

      assert mix_exs(igniter) =~
               ~r/@all_targets \[\s*:other,\s*:my_board,\s*#{inspect(@target)}\s*\]/

      assert mix_exs(igniter) =~ ~s|{:nerves_pack, "~> 0.7", targets: @all_targets}|
      assert dep(igniter) == {@app, requirement(), runtime: false, targets: @target}
    end

    test "is idempotent" do
      nerves_project(
        [~s|{:nerves_pack, "~> 0.7", targets: @all_targets}|],
        "  @all_targets [:other]\n"
      )
      |> install()
      |> apply_igniter!()
      |> install()
      |> assert_unchanged()
    end

    test "doesn't change a project that's already set up" do
      nerves_project(
        [~s|{#{inspect(@app)}, "~> 0.1", runtime: false, targets: #{inspect(@target)}}|],
        "  @all_targets [#{inspect(@target)}, :other]\n"
      )
      |> install()
      |> assert_unchanged()
    end

    test "adds the system and a notice to projects that don't use Nerves" do
      igniter = test_project() |> install()

      assert dep(igniter) == {@app, requirement(), runtime: false, targets: @target}
      assert_has_notice(igniter, &(&1 =~ "mix igniter.install nerves --target #{@target}"))
    end

    test "doesn't add a notice to Nerves projects" do
      assert nerves_project([]) |> install() |> Map.fetch!(:notices) == []
    end
  else
    import ExUnit.CaptureIO

    test "says what's missing" do
      output =
        capture_io(:stderr, fn ->
          assert catch_exit(Mix.Task.rerun(@task, [])) == {:shutdown, 1}
        end)

      assert output =~ "The task '#{@task}' requires"
      assert output =~ "{#{inspect(@app)}, "
      assert output =~ "runtime: false, targets: #{inspect(@target)}}"
    end
  end
end
