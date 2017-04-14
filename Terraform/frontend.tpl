  [frontends.${name}]
    backend = "${name}"
    [frontends.${name}.routes.host]
    rule = "Host:${name}.${domain}"
