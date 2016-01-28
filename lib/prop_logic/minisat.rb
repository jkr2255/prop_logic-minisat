require 'prop_logic'
require 'minisat'
require "prop_logic/minisat/version"

module PropLogic
  module Minisat
    class Solver
      def self.call(term)
        new.sat?(term)
      end
      
      private_class_method :new      
      
      def initialize
        @solver = ::MiniSat::Solver.new
      end
      
      def parse_variable_or_not(term)
        if term.is_a?(Variable)
          @variable_map[term]
        else
          -(@variable_map[term.terms[0]])
        end
      end
      
      def parse_or_term(term)
        if term.is_a?(OrTerm)
          @solver << term.terms.map{ |t| parse_variable_or_not(t) }
        else
          @solver << parse_variable_or_not(term)
        end
      end
      
      def sat?(term)
        cnf = term.to_cnf
        orig_variables = term.variables
        # no need to use SAT solver
        return false if cnf == False
        if cnf == True
          return True if orig_variables.length == 0
          return PropLogic.all_and(*orig_variables)
        end
        #prepare for solver
        using_variables = cnf.variables
        @variable_map = {}
        using_variables.each{ |v| @variable_map[v] = @solver.new_var }
        if cnf.is_a?(AndTerm)
          cnf.terms.each{ |t| parse_or_term t}
        else
          parse_or_term term
        end
        return false unless @solver.solve
        # return value generation
        assign_variables = using_variables & orig_variables
        extra_variables = orig_variables - assign_variables
        PropLogic.all_and(*assign_variables.map{ |v| @solver[@variable_map[v]] ? v : -v }, *extra_variables)
      end
      
    end
  end
  PropLogic.sat_solver = Minisat::Solver
end
