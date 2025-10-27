#   YAML to WireGuard config

Generate distinct WireGuard config files from a single YAML definition.

The YAML file resembles the WireGuard backend for
[netjsonconfig](https://netjsonconfig.openwisp.org/en/1.0.0/backends/wireguard.html),
with these additional keys:

| YAML key             | INI key             | INI section  |
| :------------------- | :------------------ | :----------- |
| dns                  | DNS                 | Interface    |
| mtu                  | MTU                 | Interface    |
| table                | Table               | Interface    |
| pre_up               | PreUp               | Interface    |
| post_up              | PostUp              | Interface    |
| pre_down             | PreDown             | Interface    |
| post_down            | PostDown            | Interface    |
| persistent_keepalive | PersistentKeepalive | Peer         |

##  Dependencies

-   `jsonnet`,
    either [Go](https://github.com/google/go-jsonnet)
    or [C++](https://github.com/google/jsonnet) version.

-   Go [`yq`](https://github.com/mikefarah/yq).

##  Quick start

1.  Head to the `examples` directory.

2.  Create output directories,

    ```shell
    mkdir -p json.d conf.d
    ```

3.  Generate intermediary JSON,

    ```shell
    jsonnet wg.jsonnet -m json.d
    ```

4.  Then, generate WireGuard config files to the `conf.d` directory,

    ```shell
    for i in json.d/* ; do yq < $i > conf.d/$(basename $i .json).conf ; done
    ```

