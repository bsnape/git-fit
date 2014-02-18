require_relative 'spec_helper'

describe 'test fixture setup' do

  it 'should link to a test repository' do
    path = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    repo = Rugged::Repository.new(path)
    repo.bare?.should be_false
  end

end
