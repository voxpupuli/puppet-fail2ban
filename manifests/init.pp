class fail2ban {
	define fail2ban::email($email = false, $whitelist = false) {
		$t_email = $email ? {
			false   => "root",
			default => $email,
		}

		$t_whitelist = $whitelist ? {
			false   => ["127.0.0.1"],
			default => $whitelist,
		}

		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			alias   => "jail.conf",
			content => template("fail2ban/$::lsbdistcodename/etc/fail2ban/jail.conf.erb"),
			notify  => Service["fail2ban"],
			require => Package["fail2ban"],
		}
	}

	fail2ban::email { "/etc/fail2ban/jail.conf":
		email     => "fail2ban@${::domain}",
		whitelist => [
			"127.0.0.1",
			"192.168.122.0/24"
		],
	}

	file { "/etc/fail2ban/jail.local":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "jail.local",
		source  => [
			"puppet:///modules/fail2ban/common/$::hostname/etc/fail2ban/jail.local",
			"puppet:///modules/fail2ban/common/etc/fail2ban/jail.local"
		],
		notify  => Service["fail2ban"],
		require => Package["fail2ban"],
	}

	package { "fail2ban":
		ensure => present,
	}

	service { "fail2ban":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => [
			File["jail.conf"],
			File["jail.local"],
			Package["fail2ban"]
		],
	}
}

# vim: tabstop=3