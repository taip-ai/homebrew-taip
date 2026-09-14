# Homebrew formula for the slim public `taip-connect` (SR-3/5). Push to the NEW public repo
# `taip-ai/homebrew-taip` as `Formula/taip-connect.rb`, then:  brew install taip-ai/taip/taip-connect
#
# Fill `sha256` AFTER publishing to npm:
#   shasum -a 256 "$(npm pack taip-connect --silent)"     # or from the npm registry tarball
class TaipConnect < Formula
  desc "Wire the hosted taip brain + context + taip-tools MCP servers into Claude Code"
  homepage "https://github.com/taip-ai/taip-agent"
  url "https://registry.npmjs.org/taip-connect/-/taip-connect-0.20.1.tgz"
  sha256 "8f3268d3f9e17cd8728c05126b643799cc787f5d66014c0d44cefdbeeaa60df4"
  license "UNLICENSED"

  depends_on "node" # Node >= 20 auto-installed as a dependency (SR-3)

  def install
    # Install the slim package (bundled — no runtime deps) into libexec.
    system "npm", "install", *std_npm_args

    # SR-5: bake the STABLE node opt path so `brew upgrade node` never breaks MCP connections.
    # The wrapper exports TAIP_NODE_BIN, which taip-connect writes into ~/.taip/mcp-headers, so
    # Claude Code always execs a node path that survives node version bumps.
    (bin/"taip-connect").write <<~SH
      #!/bin/bash
      export TAIP_NODE_BIN="#{Formula["node"].opt_bin}/node"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/node_modules/taip-connect/bin/connect.js" "$@"
    SH
  end

  test do
    assert_match "taip-connect", shell_output("#{bin}/taip-connect --help")
  end
end
