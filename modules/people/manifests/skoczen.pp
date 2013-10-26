class people::skoczen {
  include onepassword
  include divvy
  include jumpcut

  # OSX Config
  include osx::dock::autohide
  include osx::dock::clear_dock
  include osx::dock::dim_hidden_apps
  include osx::finder::show_all_on_desktop
  include osx::finder::unhide_library
  include osx::universal_access::ctrl_mod_zoom
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::software_update
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }

  # projects
  include projects::boxen

  $home     = "/Users/${::boxen_user}"
  $my       = "${home}/my"
  $dotfiles = "${my}/dotfiles"
  
  file { $my:
    ensure  => directory
  }

  repository { $dotfiles:
    source  => 'skoczen/dotfiles',
    require => File[$my]
  }
  file { "${home}/.bash_profile":
    ensure  => link,
    target  => "${dotfiles}/home/.bash_profile",
    require => Repository[$dotfiles]
  }
  file { "${home}/.zshrc":
    ensure  => link,
    target  => "${dotfiles}/home/.zshrc",
    require => Repository[$dotfiles]
  }

  $base = "/Users/${::boxen_user}/Library/Application Support"
  $structure = [ "${base}/Sublime Text 2", "${base}/Sublime Text 2/Packages" ]
 
  file { "${base}/Sublime Text 2/Packages/User/Default (OSX).sublime-keymap":
    content  => '[{ "keys": ["super+ctrl+r"], "command": "reveal_in_side_bar"}]',
  }->
 
  file { "${base}/Sublime Text 2/Packages/User/Preferences.sublime-settings":
      content  => '
{
"color_scheme": "Packages/Color Scheme - Default/Blackboard.tmTheme",
"detect_indentation": false,
"drawWhiteSpace": "all",
"file_exclude_patterns":
[
  "*.pyc",
  "*.pyo",
  "*.exe",
  "*.dll",
  "*.obj",
  "*.o",
  "*.a",
  "*.lib",
  "*.so",
  "*.dylib",
  "*.ncb",
  "*.sdf",
  "*.suo",
  "*.pdb",
  "*.idb",
  ".DS_Store",
  "*.pdf",
  "*.psd",
  "*.png",
  "*.gif",
  "*.jpg",
  "*.fla",
  "*.swf",
  "*.jar",
  "*.wav",
  "*.ogg",
  "*.eot",
  "*.ttf",
  "*.svg",
  "*.zip",
  "*.otf",
  "*.woff",
  "*.bz2",
  "\"",
  "*.gz",
  "*.tif",
  "*.bmp",
  "*.xls",
  "*.doc",
  ".mov",
  ".mpeg",
  "celerybeat-schedule",
  "_generated_media",
  "collected_static"
],
"folder_exclude_patterns":
[
  ".svn",
  ".git",
  ".hg",
  "CVS",
  "db",
  "collected_static",
      "media",
      "synonyms.json",
      "CACHE",
      "node_modules",
      ".vagrant"
],
"font_face": "ProFont",
"font_options":
[
  "no_antialias"
],
"font_size": 10.0,
"tab_completion": true,
"translateTabsToSpaces": true,
"translate_tabs_to_spaces": true,
  "auto_complete_selector": "source - comment, meta.tag - punctuation.definition.tag.begin"
}
'
    }

    git::config::global { 
        'alias.st': value => 'status';
        'alias.ci': value => 'commit';
        'alias.co': value => 'checkout';
        'user.name': value => 'skoczen'; 
    }

    node skoczen {
      package {
        [
          'fortune',
        ]:
      }
    }
}