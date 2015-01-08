require "spec_helper"

describe "elixir::version" do
  let(:facts) { default_test_facts }
  let(:title) { "1.0.0" }

  context "ensure => present" do
    context "default params" do
      it { should contain_class("elixir") }

      it { should contain_elixir("1.0.0").with({
        :ensure       => "installed",
        :elixir_build => "/test/boxen/elixir-build/bin/elixir-build",
        :provider     => "elixirbuild",
        :user         => "testuser",
      })}
    end

    context "when env is default" do
      it { should contain_elixir("1.0.0").with_environment({
        "CC" => "/usr/bin/cc",
        "FROM_HIERA" => "true",
      })}
    end

    context "when env is not nil" do
      let(:params) { { :env => {"SOME_VAR" => "flocka"} } }

      it { should contain_elixir("1.0.0").with_environment({
        "CC" => "/usr/bin/cc",
        "FROM_HIERA" => "true",
        "SOME_VAR" => "flocka"
      })}
    end
  end

  context "ensure => absent" do
    let(:params) { { :ensure => "absent" } }

    it { should contain_elixir("1.0.0").with_ensure("absent") }
  end
end
