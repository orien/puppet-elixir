require "spec_helper"

describe "elixir::local" do
  let(:facts) do
    {
      :boxen_home                  => "/opt/boxen",
      :boxen_user                  => "me",
      :macosx_productversion_major => "10.10"
    }
  end

  let(:title) { "/tmp" }

  context "ensure => present" do
    let(:params) { { :version => "1.0.0" } }

    it { should contain_ruby__version("1.0.0") }
    it { should contain_file("/tmp/.exenv-version").with(
      :ensure  => "present",
      :content => "1.0.0\n",
      :replace => true
    )}
  end

  context "ensure => absent" do
    let(:params) { { :ensure => "absent" } }

    it { should contain_file("/tmp/.exenv-version").with_ensure("absent") }
  end
end
