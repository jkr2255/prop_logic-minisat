require 'spec_helper'

describe PropLogic::Minisat do
  it 'has a version number' do
    expect(PropLogic::Minisat::VERSION).not_to be nil
  end

end

describe PropLogic::Minisat::Solver do
  it 'cannot be instantiated' do
    expect{PropLogic::Minisat::Solver.new}.to raise_error(NoMethodError)
  end
  
  describe '#call' do
  
    a = PropLogic.new_variable 'a'
    b = PropLogic.new_variable 'b'
    c = PropLogic.new_variable 'c'
    d = PropLogic.new_variable 'd'
    e = PropLogic.new_variable 'e'
    f = PropLogic.new_variable 'f'

  
    it 'returns True when True is given' do
      expect(PropLogic::Minisat::Solver.call(PropLogic::True)).to eq PropLogic::True
    end
    
    it 'returns one term with containing variables (for obvious term)' do
      ret = PropLogic::Minisat::Solver.call(a | ~a | b | ~b)
      expect(ret).to be_a(PropLogic::Term)
      expect(ret.variables).to contain_exactly(a, b)
    end
    
    it 'returns false with contradicted term' do
      expect(PropLogic::Minisat::Solver.call(a & ~a)).to be false
    end
   
    satisfiables = [
      a, #only variable
      ~a, #only not term
      (~a | b), #only contains or term
      (a | b) & (~b | c),
      (a >> b) & (b >> c) & ~b,
      (a &  b) | (c & d), # Tseitin conversion
      (a | ~a) & (b | c) & (d | ~e | f), # disappearing variable in reduction
    ]
    
    satisfiables.each do |term|
      context "(giving #{term})" do
        ret = PropLogic::Minisat::Solver.call(term)
        it 'returns Term' do
          expect(ret).to be_a(PropLogic::Term)
        end
        
        it 'returns Terms containing the same variables as original term' do
          expect(ret.variables).to match_array(term.variables)
        end
        
        # using Brute-force solver
        it 'returns really satisfied set' do
          expect(PropLogic::BruteForceSatSolver.call(term & ret)).not_to be false
        end
      end
    end
    
    unsatisfiables = [
      (a | ~b) & (b | ~c) & (c | ~a) & (a | b | c) & (~a | ~b | ~c),
    ]
    
    unsatisfiables.each do |term|
      context "(giving #{term})" do
        ret = PropLogic::Minisat::Solver.call(term)
        it 'returns false' do
          expect(ret).to be false
        end
      end
    end
  end
end

describe PropLogic do
  it 'uses Minisat solver' do
    expect(PropLogic.sat_solver).to be_equal(PropLogic::Minisat::Solver)
  end
end
