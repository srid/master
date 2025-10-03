# master

Dethrone "main" and restore "master" to its rightful glory.

## About

A Nix Flake-based tool that renames GitHub repository default branches from "main" to "master".

## Prerequisites

- [Nix with flakes enabled](https://nixos.asia/en/install)
- GitHub CLI (`gh`) authenticated with appropriate permissions
  - Run `nix run nixpkgs#gh auth login`

## Usage

```bash
nix run github:srid/master -- <repo-url>
```

The script will:
1. Check if the repository's default branch is "main"
2. If not, exit (nothing to do)
3. If yes, clone the repository
4. Rename the branch from "main" to "master"
5. Push the new branch and delete the old one
6. Update the repository's default branch setting

## Example

```bash
nix run github:srid/master -- https://github.com/yourname/yourrepo
```

## License

See LICENSE file for details.
