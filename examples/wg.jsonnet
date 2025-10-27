# wg.jsonnet

local y2wg = import '../y2wg.libsonnet';

local wg = importstr 'wg.yaml';

y2wg.convert(wg)

