# == Define: diamond::collector::install
#
# A puppet wrapper for installing collectors and their Python dependencies
#
# === Parameters
# [*repo_url*]
#   Repo url used to clone and install the collector (optional)
#
# [*repo_revision*]
#   Revision to use when cloning and installing the collector - can be a commit, branch, tag, etc. (optional)
#
# [*repo_provider*]
#   Clone collector repo using alternate vcsrepo provider (e.g. git, cvs, svn, etc.) default is 'git'. (optional)
#
# [*system_packages*]
#   Any required system packages (hash of package type hashes)
#
# [*python_packages*]
#   Any required Python packages (hash of python::pip hashes)
#
define diamond::collector::install (
  $repo_url,
  $repo_revision = undef,
  $repo_provider = 'git',
  $system_packages = undef,
  $python_packages = undef,
) {
  $repo_name = inline_template("<%= File.basename(@repo_url, File.extname(@repo_url)) %>")

  if $system_packages {
    create_resources('package', $system_packages, {
      before => Vcsrepo["${title}-repo"],
    })
  }

  if $python_packages {
    create_resources('::python::pip', $python_packages, {
      proxy   => $diamond::pip_proxy,
      require => $system_packages,
      before  => Vcsrepo["${title}-repo"],
    })
  }

  vcsrepo { "${title}-repo":
    ensure   => present,
    path     => "${diamond::collectors_path}/${repo_name}",
    provider => $repo_provider,
    source   => $repo_url,
    revision => $repo_revision,
    notify   => Class['diamond::service'],
  }
}
