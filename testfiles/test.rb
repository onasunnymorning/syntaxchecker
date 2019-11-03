require 'facter'

Facter.add(:prxHost) do
  confine :osfamily => 'Debian'
  setcode do
    Facter::Core::Execution.execute("/usr/bin/test -x /usr/bin/pvecm && /bin/echo 1")
  end
end 
