class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.20/boxr-macos-arm64.tar.gz"
      sha256 "9c89d78ffaa92bcdd5e74a3711b5b3a765746639b275d09b60e25e084618e8ba"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.20/boxr-macos-x86_64.tar.gz"
      sha256 "12f0da71bdc8dc9915afde952ba0068fd9c7447c9ce0fee76f74154bf379ed87"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.20/boxr-linux-arm64.tar.gz"
      sha256 "5fe9378739625b798403b6f78848921d93485670fb6e5e5b693f64c115379e82"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.20/boxr-linux-x86_64.tar.gz"
      sha256 "02451995f441cf7dbba7136c429f103e9de041ee9c5fc2e7d7c1ebe5279c90fa"
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
