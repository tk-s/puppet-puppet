# == Class: puppet::repo
#
# Installs the Puppet repo, if requested
#
class puppet::repo {

  if $::puppet::manage_repo {
    case $::osfamily {
      'Debian': {
        contain puppet::repo::apt
      }
      default: {
        notify { "A repo configuration for ${::osfamily} does not exist yet.": }
      }
    }
  }

}
