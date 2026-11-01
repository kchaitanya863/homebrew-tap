class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "MIT"
  head "https://github.com/kchaitanya863/boxr.git", branch: "main"

  on_macos do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.66/boxr-macos-arm64.tar.gz"
      sha256 "1617271f99f144991eaa90f9d7f15388960f097b03c7922bb43aede1761b8339"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.66/boxr-macos-x86_64.tar.gz"
      sha256 "f08cac9773d1195d94be5ccfb797087946ba0d514ad662b2dac9b81f954a9e96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.66/boxr-linux-arm64.tar.gz"
      sha256 "0e62221d53d73f3b3e9d9f016f1fcf2e49e7197e95b4ff0ae9a3f1f6fe0bd815"
    end
    on_intel do
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.66/boxr-linux-x86_64.tar.gz"
      sha256 "874755508c6db581fae48fea4a042fff2a43887d1d8f60773c6cede09d125f06"
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
