require 'prop_logic'
require 'minisat'

module PropLogic
  module Minisat
    #
    # Incremental solver using minisat.
    # @note currently only Ruby part is incremental.
    #
    class IncrementalSolver
      # constructor.
      # @param [Term] initial term for starting SAT solver.
      def initialize(initial_term)
        @solver = ::MiniSat::Solver.new
        # automagically add variable in Hash
        @variables_map = Hash.new { |h, k| h[k] = @solver.new_var }
        @terms = []
        @variables = []
        # true if False was added
        @contradicted = false
        add initial_term
      end

      # @return [Array] containing variables
      def variables
        @variables.dup
      end

      def term
        return False if @contradicted
        return True if @terms.empty?
        PropLogic.all_and(*@terms)
      end

      # add terms to this solver.
      # @return [IncrementalSolver] returns self
      def add(*terms)
        terms.each { |term| add_one_term term }
        self
      end

      alias_method :<<, :add

      # check if terms are satisfiable.
      # @return [Term] term satisfying conditions.
      # @return [false] if unsatisfied.
      def sat?
        return false if @contradicted
        return True if variables.empty?
        vars = []
        unless @terms.empty?
          return false unless @solver.solve
          ret_vars = variables & @variables_map.keys
          vars = ret_vars.map { |k| @solver[@variables_map[k]] ? k : ~k }
        end
        extra_vars = variables - @variables_map.keys
        PropLogic.all_and(*vars, *extra_vars)
      end

      private

      def sat_variable(maybe_inversed_variable)
        case maybe_inversed_variable
        when Variable
          @variables_map[maybe_inversed_variable]
        when NotTerm
          -@variables_map[maybe_inversed_variable.terms[0]]
        else
          raise TypeError
        end
      end

      def add_or_term(term)
        vars = if term.is_a?(OrTerm)
                 term.terms.map { |v| sat_variable v }
               else
                 [sat_variable(term)]
               end
        @solver << vars
        @terms << term
      end

      def add_one_term(term)
        @variables |= term.variables
        term = term.to_cnf
        return if term == True
        if term == False
          @contradicted = true
          return
        end
        if term.is_a?(AndTerm)
          term.terms.each { |t| add_or_term t }
        else
          add_or_term term
        end
      end

    end
  end
end
