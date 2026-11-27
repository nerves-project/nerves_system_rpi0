# SPDX-FileCopyrightText: None
#
# SPDX-License-Identifier: CC0-1.0

import Config

# Enable the Nerves integration with Mix
#
# It's left off for `mix test`. The tests are for the Igniter installer and
# don't need this system's artifact, which the integration would require.
if Mix.env() != :test do
  Application.start(:nerves_bootstrap)
end
