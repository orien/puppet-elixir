require "spec_helper"

describe "elixir::definition" do
  let(:facts) { default_test_facts }
  let(:title) { "1.0.0" }

  let(:definition_path) do
    [
      "/test",
      "boxen",
      "elixir-build",
      "share",
      "elixir-build",
      title
    ].join("/")
  end

  context "with source" do
    let(:whatever_source) { "puppet:///modules/elixir/whatever_def" }
    let(:params) { { :source => whatever_source } }

    it { should contain_file(definition_path).with_source(whatever_source) }
  end

  it { should contain_class("elixir") }
  it { should contain_class("elixir::build") }
  it { should contain_file(definition_path).with({
    :source  => "puppet:///modules/elixir/definitions/#{title}"
  })}
end
