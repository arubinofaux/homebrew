require 'formula'

class Riemann < Formula
  homepage 'http://riemann.io'
  url 'http://aphyr.com/riemann/riemann-0.2.6.tar.bz2'
  sha1 '254b11f7d9b0c575ca18915f0ecb3070de4231bd'

  def shim_script
    <<-EOS.undent
      #!/bin/bash
      if [ -z "$1" ]
      then
        config="#{etc}/riemann.config"
      else
        config=$@
      fi
      exec "#{libexec}/bin/riemann" "$config"
    EOS
  end

  def install
    if (etc/'riemann.config').exist?
      (prefix/'etc').install 'etc/riemann.config' => 'riemann.config.guide'
    else
      etc.install 'etc/riemann.config'
    end

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    (bin+'riemann').write shim_script
  end

  def caveats; <<-EOS.undent
    You may also wish to install these Ruby gems:
      riemann-client
      riemann-tools
      riemann-dash
    EOS
  end
end
