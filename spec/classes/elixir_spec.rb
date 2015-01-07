require "spec_helper"

RSpec.describe "elixir" do

  let(:facts) { default_test_facts }
  let(:default_params) { { :prefix => "/test/boxen" } }
  let(:params) { default_params }

  it { should contain_class("elixir::build") }
  it { should contain_file("/opt/elixirs") }
  it { should contain_class("elixir::exenv") }
  it { should contain_class("boxen::config") }
  it { should contain_boxen__env_script("elixir") }

  it { should contain_file("/opt/elixirs").with(
    :ensure => "directory",
    :owner  => "testuser",
  ) }
end
