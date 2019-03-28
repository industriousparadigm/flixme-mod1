require_relative '../config/environment.rb'

$LOADED_FEATURES << 'fake/active_support/core_ext/hash'

new_cli = CLI.new
new_cli.start
