# Hypr Builder

A containerized build system for the Hypr ecosystem. This project automates the building of interdependent components using Podman containers, and extracts compiled binaries into a release tarball.

## Project Structure

    packages/
      └── <component>/
          └── Containerfile

    scripts/
      └── build.sh      # Wrapper to build a package container with Podman

    config.yaml         # Defines build order and extracted executables

## Features

- Builds components in dependency order
- Uses Podman for container-based isolation
- Extracts binaries from images into a tarball
- Triggers GitHub Releases from tags

## Configuration

### config.yaml

    build-order:
      - base
      - hyprutils
      - hyprcursor
      - hyprlock
      - Hyprland

    executables:
      Hyprland:
        - /hypr/Hyprland/build/Hyprland
        - /hypr/Hyprland/build/hyprctl/hyprctl
      hyprlock:
        - /hypr/hyprlock/build/hyprlock

- `build-order`: Defines the sequence in which containers are built
- `executables`: Paths inside each container to be extracted and included in the release

## Usage

### Local Build (Debugging)

    # Build a single component
    bash scripts/build.sh Hyprland

    # Extract executables (requires container to be built)
    podman create --name tmp hypr-builder:Hyprland-latest
    podman cp tmp:/hypr/Hyprland/build/Hyprland ./Hyprland
    podman rm tmp

## GitHub Actions Workflow

The workflow:

1. Builds each container 
2. Extracts binaries based on `config.yaml`
3. Bundles them into `hypr-artifacts.tar.gz`
4. Creates a GitHub Release with the tarball

### Triggered by:

- Pushing a tag like `v1.0.0`

## Clean Up

To delete a tag and rerun a release:

    git tag -d v1.0.0
    git push origin --delete v1.0.0

## License

MIT — feel free to reuse or adapt.

## Contributing

PRs welcome — especially around optimizing build speed or adding support for new components.

