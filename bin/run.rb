require_relative '../config/environment.rb'
require_relative '../lib/kaizoku.rb'

new_cli = Kaizoku::CommandLineInterface.new
new_cli.run
