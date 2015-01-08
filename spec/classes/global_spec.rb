require "spec_helper"

describe "elixir::global" do
  let(:facts) { default_test_facts }
  let(:params) { { :version => "1.0.0" } }

  it { should contain_file("/test/boxen/exenv/version").that_requires("Elixir::Version[1.0.0]") }
end
