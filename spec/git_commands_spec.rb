require_relative 'spec_helper'

describe 'git commands' do

  before(:all) do
    @git_repo_path    = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @cloned_repo_path = File.dirname(__FILE__) + '/fixtures/testrepo/'
    FileUtils.rm_rf @cloned_repo_path if Dir.exist? @cloned_repo_path
    `git clone #{@git_repo_path} #{@cloned_repo_path}`
    @git_lib = GitFit::GitLib.new
    Dir.chdir @cloned_repo_path
  end

  it "should list all the file paths in the repository's working copy" do
    @git_lib.get_file_list.should match_array ['test.txt', 'test/blah/hello.txt']
  end

  it 'should get the commit author for a given commit' do
    @git_lib.get_commit_author('25097b1').should eq 'Ben Snape'
  end

  it 'should get the UNIX timestamp for a given commit' do
    expected_time = 1392722405
    @git_lib.get_commit_date('25097b1').should eq expected_time
  end

  it 'should get the revision list for a given commit' do
    expected_revision_list = ['25097b13910521f43a3bbc5236973bcc2a06093b', 'b224a986d123ae3718b1e8762e596b111a4367e0']
    @git_lib.get_revision_list('HEAD').should match_array expected_revision_list
  end

  it 'should get the commit count for a given branch' do
    @git_lib.get_commit_count_for_branch('master').should eq 2
  end

  it 'should return the size of a file in bytes for a given filepath' do
    @git_lib.get_file_size('test/blah/hello.txt').should eq 7
  end

  it 'should calculate the size of all files in the working copy' do
    expected_file_sizes = { 2307 => 'test.txt', 7 => 'test/blah/hello.txt' }
    @git_lib.calculate_file_sizes.should == expected_file_sizes
  end

end
