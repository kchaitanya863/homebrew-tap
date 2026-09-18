class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.33/boxr-macos-arm64.tar.gz"
      sha256 "f31039d545784c4f2f47c14c6d3be6d8abe5e040e271fe15b359f1d7931ae058"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.33/boxr-macos-x86_64.tar.gz"
      sha256 "f9018e73d69ddbcdb8cf20f62836542083184db81f6e856d5295be90b4f5adb8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.33/boxr-linux-arm64.tar.gz"
      sha256 "f76fb26a18b907a00aa81b1e2b7ff5b2f0b41158d1da2817998a43bb471d17cd"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.33/boxr-linux-x86_64.tar.gz"
      sha256 "ab7c84021e1e6472ea725ce76ab4c427bb9876c955854aea7b0f7608ba82bd18"
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
      (Optional) Docker Drop-in Alias:
      If you want 'docker' commands to transparently invoke boxr:
        boxr alias --install
      or add to your shell profile (~/.zshrc or ~/.bashrc):
        alias docker="boxr"
    EOS
  end

  test do
    assert_match "boxr", shell_output("#{bin}/boxr --version")
    assert_match "Containers:", shell_output("#{bin}/boxr info")
  end
end
