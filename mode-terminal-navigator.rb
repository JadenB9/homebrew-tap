class ModeTerminalNavigator < Formula
  desc "Interactive terminal application for navigating and managing development workflows on macOS with integrated AI assistant"
  homepage "https://github.com/JadenB9/mode-terminal-navigator"
  url "https://github.com/JadenB9/mode-terminal-navigator/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c2e79b1b8b685d205628931f48dc4e263b63227078d5f671bbcbbe2b6a460c4b"
  version "1.0.0"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ollama" => :optional

  def install
    # Install to libexec to avoid conflicts
    libexec.install Dir["*"]
    
    # Create wrapper script that uses user's pip packages
    (bin/"mode").write <<~EOS
      #!/bin/bash
      cd #{libexec}
      
      # Check if dependencies are installed, if not, install them
      if ! #{Formula["python@3.11"].opt_bin}/python3 -c "import rich, inquirer, requests, psutil" 2>/dev/null; then
        echo "Installing Python dependencies..."
        #{Formula["python@3.11"].opt_bin}/pip3 install --user rich inquirer requests psutil
      fi
      
      exec #{Formula["python@3.11"].opt_bin}/python3 mode.py "$@"
    EOS
    
    # Make wrapper executable
    chmod 0755, bin/"mode"
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