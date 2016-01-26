require 'prop_logic'
require 'minisat'
require "prop_logic/minisat/version"

module PropLogic
  module Minisat
    class Solver
      def self.call(term)
        new.sat?(term)
      end
      
      def sat?(term)
      end
      
      private_class_method :new
    end
  end
  PropLogic.sat_solver = Minisat::Solver
end
