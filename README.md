



# How to build


## Get the updated hash
Use `nix-prefetch-github` to get the updated hash for the new version.
```
nix-prefetch-github Aider-AI aider --rev v0.75.1
```

## Update aider-package.nix
Update the version and the has in aider-packag.nix

## Build
From repo root, run:
```
nix build .
```
## Push
Update rev is ready to use.

```
