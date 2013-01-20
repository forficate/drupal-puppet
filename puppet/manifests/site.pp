Exec {
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

Exec["apt-update"] -> Package <| |>

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

node default {
    include truth::enforcer
}

