# y2wg.jsonnet

local y2wg = {

  filterDefined(obj, key_dict): {
    [each.key]: obj[each.value]
      for each in std.objectKeysValues(key_dict)
        if std.objectHas(obj, each.value)
  },

  interface(wg):
    std.manifestIni({
      sections: {
        Interface: $.filterDefined(wg, {
          Address:    'address',
          ListenPort: 'port',
          PrivateKey: 'private_key',
          DNS:        'dns',
          MTU:        'mtu',
          Table:      'table',
          PreUp:      'pre_up',
          PostUp:     'post_up',
          PreDown:    'pre_down',
          PostDown:   'post_down',
        }),
      },
    }),

  peer(peer): (
    local comment = '# ' + peer.name;

    local body =
      std.manifestIni({
        sections: {
          Peer: $.filterDefined(peer, {
              PublicKey:           'public_key',
              PresharedKey:        'preshared_key',
              PersistentKeepalive: 'persistent_keepalive',
            }) + {
              AllowedIPs: std.join(', ', peer.allowed_ips),

              // Allow two alternatives:
              //
              // 1. separated host and port:
              //
              //    endpoint_host: '10.11.12.1'
              //    endpoint_port: '51820'
              //
              // 2. or at once:
              //
              //    endpoint_host: '10.11.12.1:51820'
              //
              [if std.objectHas(peer, 'endpoint_host') then 'Endpoint']:
                std.join(':', [
                  peer.endpoint_host,
                  if std.objectHas(peer, 'endpoint_port')
                    then std.toString(peer.endpoint_port),
                ]),
          }
        }
      });

    std.join('\n', [
      comment,
      body,
    ])
  ),

  peers(wg):
    std.join('\n', [self.peer(each) for each in wg.peers]),

  config(wg): (
    local comment = '# ' + wg.name;

    std.join('\n', [
      comment,
      self.interface(wg),
      self.peers(wg)
    ])
  ),

  filename(wg):
    std.split(wg.name, ' ')[0] + '.json',

  convert(wg_yaml): {
    [$.filename(each)]: $.config(each)
      for each in std.parseYaml(wg_yaml).wireguard
  },

};

{
  convert:: y2wg.convert,
}

