class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.26/boxr-macos-arm64.tar.gz"
      sha256 "152bbda1bd488dbcbc2bb3af910016ed7afb2396e275836bb615ed8e0bd97235"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.26/boxr-macos-x86_64.tar.gz"
      sha256 "152bbda1bd488dbcbc2bb3af910016ed7afb2396e275836bb615ed8e0bd97235"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.26/boxr-linux-arm64.tar.gz"
      sha256 "4f6ec8d073e1979b2768f2ce683898f0113f7ab65adec15cd3c27b4159f7c192"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.26/boxr-linux-x86_64.tar.gz"
      sha256 "4f6ec8d073e1979b2768f2ce683898f0113f7ab65adec15cd3c27b4159f7c192"
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
