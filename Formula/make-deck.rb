class MakeDeck < Formula
  desc "Standalone pandoc beamer presentation generator"
  homepage "https://github.com/hubrix/pandoc-beamer-how-to"
  url "https://github.com/hubrix/pandoc-beamer-how-to/archive/refs/heads/macos-build-improvements.tar.gz"
  version "1.0.0"
  sha256 "cd3a837b05850cad101c35287f2f6f9348cf8a43f41cb14a696f6a0b81883dee"
  license "MIT"
  head "https://github.com/hubrix/pandoc-beamer-how-to.git", branch: "macos-build-improvements"

  depends_on "pandoc"

  # Recommend tectonic as the preferred TeX engine, but allow alternatives
  def caveats
    <<~EOS
      make-deck requires a TeX engine to generate PDFs.
      
      For the best experience, install tectonic (recommended):
        brew install tectonic
      
      Alternatively, you can install a full TeX distribution:
        brew install --cask mactex-no-gui
      
      Or use MacTeX from: https://www.tug.org/mactex/
    EOS
  end

  def install
    # Generate the standalone make_deck executable
    system "make", "make_deck"
    
    # Install the executable
    bin.install "make_deck"
    
    # Install documentation
    doc.install "README.md"
    doc.install "LICENSE" if File.exist?("LICENSE")
  end

  test do
    # Test help functionality
    assert_match "Usage: make_deck", shell_output("#{bin}/make_deck --help")
    
    # Create a simple test markdown file
    (testpath/"test.md").write <<~EOS
      ---
      title: "Test Presentation"
      author: "Homebrew Test"
      theme: "Frankfurt"
      colortheme: "beaver"
      fonttheme: "professionalfonts"
      fontsize: 11pt
      aspectratio: 169
      date: "Test Date"
      toc: true
      ---
      
      # Test
      
      This is a test slide.
      
      ## Features
      
      - Point one
      - Point two
      
      # Conclusion
      
      It works!
    EOS
    
    # Test PDF generation (only if tectonic is available)
    if which("tectonic")
      system bin/"make_deck", testpath/"test.md", testpath/"test.pdf"
      assert_predicate testpath/"test.pdf", :exist?
      assert_operator (testpath/"test.pdf").size, :>, 1000, "Generated PDF should be larger than 1KB"
    else
      # If no TeX engine available, just test that it fails gracefully
      output = shell_output("#{bin}/make_deck #{testpath}/test.md #{testpath}/test.pdf 2>&1", 1)
      assert_match(/No TeX engine found|pandoc is not installed/, output)
    end
  end
end