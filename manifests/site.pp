require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}",
    "RBENV_VERSION=1.9.3"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  # if $::root_encrypted == 'no' {
  #   fail('Please enable full disk encryption and try again')
  # }

  # node versions
  include nodejs::v0_4
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0
  class { 'ruby::global':
     version => '1.9.3'
  }

  # stuff we always need
  include python

  # stuff we always want
  include chrome
  include chrome::canary
  include dropbox
  include googledrive
  include java
  include homebrew
  include firefox
  include github_for_mac
  include hipchat
  include menumeters
  include quicksilver
  include unarchiver

  include sublime_text_2
  sublime_text_2::package { 
    'GitGutter': source => "jisaacks/GitGutter";
    'sublime-coffee-compile': source => "surjikal/sublime-coffee-compile";
    'coffee-script-tmbundle': source => "jashkenas/coffee-script-tmbundle";
    'sublimetext-markdown-preview': source => "revolunet/sublimetext-markdown-preview";
    'Solarized': source => "SublimeColors/Solarized";
    'Package Control': source => "wbond/Package Control";
    'sublime-text-puppet': source => "eklein/sublime-text-puppet";
    'LESS-sublime': source => "danro/LESS-sublime";
    'Jasmine': source => "gja/sublime-text-2-jasmine";
    'Djaneiro': source => "squ1b3r/Djaneiro";
    'SublimeCodeIntel': source => "SublimeCodeIntel/SublimeCodeIntel";
    'SublimeJEDI': source => "srusskih/SublimeJEDI";
    'SublimeLinter': source => "SublimeLinter/SublimeLinter";
    'SublimePrettyJson': source => "dzhibas/SublimePrettyJson";
    'Cucumber': source => "npverni/cucumber-sublime2-bundle";
  }

  include heroku
  heroku::plugin { 'accounts':
    source => 'ddollar/heroku-accounts'
  }

  # common, useful packages
  package {
    [
      # via homebrew
      'ack',
      'findutils',
      'gnu-tar',
      'fortune',
      'git-flow',
      'icu4c',
    ]: ;
    'virtualenv':
      ensure => installed,
      provider => pip;
    

    'virtualenvwrapper':
      ensure => installed,
      provider => pip;

    'fabric':
      ensure => installed,
      provider => pip;

  }

  class { 'nodejs::global': version => 'v0.10' }
  nodejs::module { 'karma':
    module       => 'karma',
    node_version => 'v0.10',
  }
  nodejs::module { 'coffee-script':
    module       => 'coffee-script',
    node_version => 'v0.10',
  }
  nodejs::module { 'hubot':
    module       => 'hubot',
    node_version => 'v0.10',
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
