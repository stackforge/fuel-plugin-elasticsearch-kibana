# Define Resource Type: disk_management::lvm_fs

define disk_management::lvm_fs (
  $disks,
  $lv_name,
  $vg_name,
  $fstype = 'ext3',
  $group = 'root',
  $owner = 'root',
) {

  $directory = $title
  $device  = "/dev/${vg_name}/${lv_name}"

  # Creates the logical volume
  lvm::volume { $lv_name:
    ensure => present,
    pv     => $disks,
    vg     => $vg_name,
    fstype => $fstype,
  }

  # create the directory
  file { $directory:
    ensure => directory,
    group  => $group,
    owner  => $owner,
  }

  # Mount the directory
  mount { $directory:
    ensure  => mounted,
    device  => $device,
    fstype  => $fstype,
    options => 'defaults',
    require => [File[$directory], Lvm::Volume[$lv_name]],
  }
}
