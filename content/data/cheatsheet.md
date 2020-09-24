---
title: "cheatsheet"
date: 2020-09-21T21:43:46+02:00
draft: true
---

## kubernetes

### execute random stuff on kops nodes

```
# kops hostname format: ip-<c-i-d-r>.<region>.compute.internal

CMD="echo dummy"
LIMIT="node-role.kubernetes.io/nodes="
for h in $(k get nodes -l ${LIMIT} -o custom-columns=name:.metadata.name --no-headers | cut -d . -f1 | sed 's/ip-//g' | sed 's/-/./g'); do
  ssh $h "${CMD}";
done
```
