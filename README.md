# homebrew-taip

Homebrew tap for [`taip-connect`](https://www.npmjs.com/package/taip-connect) — the slim installer
that wires the hosted **taip** brain + context + taip-tools MCP servers into Claude Code.

## Install

```sh
brew install taip-ai/taip/taip-connect      # Node >= 20 auto-installed
```

or:

```sh
brew tap taip-ai/taip
brew install taip-connect
```

Then wire your machine (with the Cloudflare Access service-token file the operator hands you):

```sh
taip-connect --from-file <creds-file> --yes
```

## What it installs

`taip-connect` writes the Claude Code MCP config for the hosted **brain**, **context**, and
**taip-tools** servers and stores your Cloudflare Access token in the OS keyring (or a 0600 file).
It ships **no rule content and no keys** — tenant content stays behind Cloudflare Access.

- npm: <https://www.npmjs.com/package/taip-connect>
- Source: <https://github.com/taip-ai/taip-agent>

## Maintainers — cutting a new version

On a new `taip-connect` npm release, bump `url` (version) and `sha256` in `Formula/taip-connect.rb`:

```sh
shasum -a 256 "$(npm pack taip-connect --silent)"
```
