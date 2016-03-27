require 'prop_logic'
require 'minisat'
require 'prop_logic/minisat/version'
require 'prop_logic/minisat/incremental_solver'

module PropLogic
  module Minisat
    module Solver
      def self.call(term)
        IncrementalSolver.new(term).sat?
      end
    end
  end
  PropLogic.sat_solver = Minisat::Solver
  PropLogic.incremental_solver = Minisat::IncrementalSolver
end
