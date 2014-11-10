package {"docker-io":
  ensure => present
}

service {"docker":
   ensure => running
}

Package["docker-io"] -> Service["docker"]
