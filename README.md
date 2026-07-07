# blazingly-fasb

Stuff to determine possible bottlenecks in fasb.

## Dependency installation

This project depends on the Python bindings for fasb that we implemented in a fork of the original repo. To install this you need to first install maturin:

```bash
# macOS (Homebrew)
brew install maturin

# pipx (any OS)
pipx install maturin

# uv (any OS)
uv tool install maturin

# pip into the project venv
pip install maturin

# Arch Linux
pacman -S maturin

# from source (requires a Rust toolchain)
cargo install --locked maturin
```

The fork is expected to live next to this repo, so the layout should look like:

```
.
├── blazingly-fasb/
└── fasb/
```

So assuming youre currently in blazingly-fasb and have gh-cli installed execute

```bash
cd ..
gh repo clone MapManagement/fasb
cd blazingly-fasb
```

Now you can continue.

Then sync the environment with [uv](https://docs.astral.sh/uv/):

```bash
uv sync
```

This pulls in `fasb` as an editable dependency (see `[tool.uv.sources]` in `pyproject.toml`) and builds the bindings via maturin on the first run.

To check that everything is wired up:

```bash
uv run python main.py
```

## Developer Info

Use Jedi as a Language Server, this makes it easier to get completion for fasb python bindings.

In VS Code, drop this into `.vscode/settings.json`:

```json
{
  "python.languageServer": "Jedi",
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv.nosync/bin/python"
}
```

In other configs (Neovim, Helix, Emacs, …), install `jedi-language-server` into the project venv and point your LSP client at it:

```bash
uv pip install jedi-language-server
```
