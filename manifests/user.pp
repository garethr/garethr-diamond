class diamond::user {
    if $::diamond::manage_user {
        user { $::diamond::user:
            ensure  => present,
            home    => '/var/log/diamond',
            system  => true,
            shell   => '/usr/sbin/nologin',
        }
    }
}
