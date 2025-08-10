class ModeTerminalNavigator < Formula
  desc "Interactive terminal application for navigating and managing development workflows on macOS with integrated AI assistant"
  homepage "https://github.com/JadenB9/mode-terminal-navigator"
  url "https://github.com/JadenB9/mode-terminal-navigator/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ollama" => :optional

  def install
    # Install to libexec to avoid conflicts
    libexec.install Dir["*"]
    
    # Create wrapper script
    (bin/"mode").write <<~EOS
      #!/bin/bash
      cd #{libexec}
      exec python3 mode.py "$@"
    EOS
    
    # Make wrapper executable
    chmod 0755, bin/"mode"
    
    # Install Python dependencies
    system Formula["python@3.11"].opt_bin/"pip3", "install", "--target=#{libexec}/lib", 
           "rich", "inquirer", "requests", "psutil"
  end

  def post_install
    puts ""
    puts "🎉 Mode Terminal Navigator installed successfully!"
    puts ""
    puts "📖 Quick Start:"
    puts "   1. Run: mode"
    puts "   2. Press TAB for AI chat (requires Ollama)"
    puts ""
    puts "🤖 For AI features, install Ollama:"
    puts "   brew install ollama"
    puts "   ollama pull dolphin-mistral:7b"
    puts ""
  end

  test do
    # Test that the mode command exists and shows help
    assert_match "Mode Terminal Navigator", shell_output("#{bin}/mode --version")
  end
end