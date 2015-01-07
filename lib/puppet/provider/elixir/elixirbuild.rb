require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:elixir).provide(:elixirbuild) do
  include Puppet::Util::Execution

  def self.elixirlist
    @elixirlist ||= Dir["/opt/elixirs/*"].map do |elixir|
      if File.directory?(elixir) && File.executable?("#{elixir}/bin/elixir")
        File.basename(elixir)
      end
    end.compact
  end

  def self.instances
    elixirlist.map do |elixir|
      new({
        :name     => elixir,
        :version  => elixir,
        :ensure   => :present,
        :provider => "elixirbuild",
      })
    end
  end

  def query
    if self.class.elixirlist.member?(version)
      { :ensure => :present, :name => version, :version => version}
    else
      { :ensure => :absent,  :name => version, :version => version}
    end
  end

  def create
    destroy if File.directory?(prefix)

    if Facter.value(:offline) == "true"
      if File.exist?("#{cache_path}/elixir-#{version}.tar.gz")
        build_elixir
      else
        raise Puppet::Error, "Can't install elixir because we're offline and the tarball isn't cached"
      end
    else
      try_to_download_precompiled_elixir || build_elixir
    end
  rescue => e
    raise Puppet::Error, "install failed with a crazy error: #{e.message} #{e.backtrace}"
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private
  def try_to_download_precompiled_elixir
    Puppet.debug("Trying to download precompiled elixir for #{version}")
    output = execute "curl --silent --fail #{precompiled_url} >#{tmp} && tar xjf #{tmp} -C /opt/elixirs", command_options.merge(:failonfail => false)

    output.exitstatus == 0
  ensure
    FileUtils.rm_f tmp
  end

  def build_elixir
    execute "#{elixir_build} #{version} #{prefix}", command_options.merge(:failonfail => true)
  end

  def tmp
    "/tmp/elixir-#{version}.tar.bz2"
  end

  def precompiled_url
    base = Facter.value(:boxen_download_url_base) ||
      "http://#{Facter.value(:boxen_s3_host)}/#{Facter.value(:boxen_s3_bucket)}"
    
    %W(
      #{base}
      /
      elixirs
      /
      #{Facter.value(:operatingsystem)}
      /
      #{os_release}
      /
      #{CGI.escape(version)}.tar.bz2
    ).join("")
  end

  def os_release
    case Facter.value(:operatingsystem)
    when "Darwin"
      Facter.value(:macosx_productversion_major)
    when "Debian", "Ubuntu"
      Facter.value(:lsbdistcodename)
    else
      Facter.value(:operatingsystem)
    end
  end

  def elixir_build
    @resource[:elixir_build]
  end

  def command_options
    {
      :combine            => true,
      :custom_environment => environment,
      :uid                => @resource[:user],
      :failonfail         => true,
    }
  end

  def environment
    return @environment if defined?(@environment)

    @environment = Hash.new

    @environment["ELIXIR_BUILD_CACHE_PATH"] = cache_path

    @environment.merge!(@resource[:environment])
  end

  def cache_path
    @cache_path ||= if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/cache/elixirs"
    else
      "/tmp/elixirs"
    end
  end

  def version
    @resource[:version]
  end

  def prefix
    "/opt/elixirs/#{version}"
  end
end
