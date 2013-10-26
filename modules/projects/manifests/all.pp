class projects::all {

  class python::config {
    include boxen::config
  
    $venv_home = "${boxen::config::datadir}/.virtualenvs"
  }

  include_all_projects()
}
