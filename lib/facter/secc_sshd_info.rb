####################################
### MANAGED BY PUPPET ['facter'] ###
### DON'T CHANGE THIS FILE HERE  ###
### DO IT ON THE PUPPET MASTER!  ###
####################################
#
# Fact: secc_sshd_info
#
# Purpose: Display the ssh version and the date of the lastest update.
#
# Resolution: Fact is useful for monitoring.
#
require 'facter'

Facter.add(:secc_sshd_info, :type => :aggregate) do
  confine do

    if Facter.value(:osfamily) != 'windows'
      ssh_grep = Facter::Core::Execution.exec('rpm -qa --last | egrep "openssh-[0-9.0-9]"')
      version_ssh = ssh_grep.split(" ")
      version = version_ssh[0]
      
      if ssh_grep.empty? or ssh_grep.match(/^[a-zA-Z0-9]+/)
        date_split = ssh_grep.split(" ")
        last_update = date_split[2..5].join(" ")
      end
      
      case date_split[2]
      when 'Jan' then month = 1
      when 'Feb' then month = 2
      when 'Mar' then month = 3
      when 'Apr' then month = 4
      when 'May' then month = 5
      when 'Jun' then month = 6
      when 'Jul' then month = 7
      when 'Aug' then month = 8
      when 'Sep' then month = 9
      when 'Oct' then month = 10
      when 'Nov' then month = 11
      when 'Dec' then month = 12
      end
      
      year = date_split[5].to_i
      month = month.to_i
      day = date_split[3].to_i
      time = date_split[4]
      time_split = time.split(":")
      hours = time_split[0].to_i
      minutes = time_split[1].to_i
      seconds = time_split[2].to_i
      
      last_update_unixtime = DateTime.new(year,month,day,hours,minutes,seconds).strftime('%s')
      
      chunk(:version) do
        secc_sshd_info_hash = {}
       	secc_sshd_info_hash["version"] = version
       	secc_sshd_info_hash
      end
      
      chunk(:last_update)do
      	secc_sshd_info_hash = {}
      	secc_sshd_info_hash["last_update"] = last_update
      	secc_sshd_info_hash
      end

      chunk(:last_update_unixtime) do
      	secc_sshd_info_hash = {}
      	secc_sshd_info_hash["last_update_unixtime"] = last_update_unixtime
      	secc_sshd_info_hash
      end
    end
  end
end