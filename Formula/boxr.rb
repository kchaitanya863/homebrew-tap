class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.25/boxr-macos-arm64.tar.gz"
      sha256 "68712de8259b0ac64edddea884ee095b1a2c823be928db714d81b895ef4a4ce1"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.25/boxr-macos-x86_64.tar.gz"
      sha256 "68712de8259b0ac64edddea884ee095b1a2c823be928db714d81b895ef4a4ce1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.25/boxr-linux-arm64.tar.gz"
      sha256 "81b3d0001835055913922f5b440a275329dbb6ae0784fb9fb39a1cf9a31bcebc"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.25/boxr-linux-x86_64.tar.gz"
      sha256 "81b3d0001835055913922f5b440a275329dbb6ae0784fb9fb39a1cf9a31bcebc"
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
