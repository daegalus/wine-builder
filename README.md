# wine-builder

This is a fairly generic wine builder. It should be able to build any wine directory.

## Building

1. Download the wine src, either official or various forks.
2. Extract and navigate to the folder.
3. Run the docker image in the folder, using bind mount

```sh
cd path-to/wine-source-folder/

# you can use `docker` instead of `podman`
podman run -v ./:/wine-builder/wine-src wine-builder
```

The script defaults to 4 threads. If you wish to use more for faster builds, set the `BUILD_THREADS` env var as so

```sh
podman run -e BUILD_THREADS=48 -v ./:/wine-builder/wine-src wine-builder
```

Finally, if you are on Fedora or any distro using SELinux, you need to append a `:Z` to the end of the bind mount.

```sh
podman run -v ./:/wine-builder/wine-src:Z wine-builder
```
