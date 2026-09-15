class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.17/boxr-macos-arm64.tar.gz"
      sha256 "656f929fb49d3cf51b1b7682882d67d764719260efb2003843dbbb8ebfbd22a5"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.17/boxr-macos-x86_64.tar.gz"
      sha256 "43407c3b051f62b29cdf26b1322f03db05916953ce2b6ca8c657f0285338413c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.17/boxr-linux-arm64.tar.gz"
      sha256 "7c9c156d57cc9c75d68ea890268da53fdac34f943b0af709b9940752ff42978b"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.17/boxr-linux-x86_64.tar.gz"
      sha256 "bad5eada442d9209f3c2c4ee46c3340c68472b29e18638e275ea9ab92af12a1d"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "bin/boxr"
    end

    # Shell completions
    bash_completion.install "completions/boxr.bash" => "boxr" if File.exist?("completions/boxr.bash")
    zsh_completion.install "completions/_boxr" => "_boxr" if File.exist?("completions/_boxr")
    fish_completion.install "completions/boxr.fish" => "boxr.fish" if File.exist?("completions/boxr.fish")
  end

  service do
    run [opt_bin/"boxr", "daemon"]
    keep_alive true
    log_path var/"log/boxr.log"
    error_log_path var/"log/boxr.log"
    working_dir var
  end

  def caveats
    <<~EOS
      To enable the docker drop-in alias wrapper:
        boxr alias --install
      or add to your shell profile:
        export PATH="$HOME/.boxr/bin:$PATH"
    EOS
  end

  test do
    assert_match "boxr", shell_output("#{bin}/boxr --version")
    assert_match "Containers:", shell_output("#{bin}/boxr info")
  end
end
