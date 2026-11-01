class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "MIT"
  head "https://github.com/kchaitanya863/boxr.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.65/boxr-macos-arm64.tar.gz"
      sha256 "790b212aa633ae713044f6cd2602a066f4a9d572c29277e2f9a249600aeb06c8"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.65/boxr-macos-x86_64.tar.gz"
      sha256 "4d728a8eb51c2c1809dfbf92b6fc689132bbe6f51dceae1ad15379e27b68cc12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.65/boxr-linux-arm64.tar.gz"
      sha256 "2ab7d2b8da1f4f09dfb589db0764d9a466d1e66719a929057e2e22cad6f6ea45"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.65/boxr-linux-x86_64.tar.gz"
      sha256 "8b02a748bf1ec598b310503b0ef840adc25e6944e62c213626cad482dcd7900a"
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
