  [frontends.${name}]
    backend = "${name}"
    passHostHeader = true
    [frontends.${name}.routes.host]
    rule = "Host:${name}.${domain}"
