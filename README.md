# NervesSystemRpi

[![Build Status](https://travis-ci.org/nerves-project/nerves_system_rpi.png?branch=master)](https://travis-ci.org/nerves-project/nerves_system_rpi)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add nerves_system_rpi to your list of dependencies in `mix.exs`:

        def deps do
          [{:nerves_system_rpi, "~> 0.4.0"}]
        end

  2. Ensure nerves_system_rpi is started before your application:

        def application do
          [applications: [:nerves_system_rpi]]
        end
