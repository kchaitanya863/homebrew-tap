class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.34/boxr-macos-arm64.tar.gz"
      sha256 "95d23223502450d48d52c991fc8986e85bd17dfd4fd8a9d1872b276e027449f2"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.34/boxr-macos-x86_64.tar.gz"
      sha256 "defc0e61d812bfc414ffd99232e1d83a8f5b01cf67a38119cf8a07e9c3aba9a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.34/boxr-linux-arm64.tar.gz"
      sha256 "c5ed8b061e99143e4fd5c7013331031b3d437dc3cdbd3b50432232cf4a872e71"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.34/boxr-linux-x86_64.tar.gz"
      sha256 "c21cf2d0318f00756a8a9177feeba342a671dab7273d5394ffa5f1092fbf6b63"
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
