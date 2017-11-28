#
# Cookbook Name:: Group132
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
######################### Read Config ##############################################	
$lines = File.read('G:\integral\app\group\deployv2\config\webconfig2.txt').split("\n")
$lines.each_with_index {|line, i|
		########################### xml #################
	if line.include? "Home Deploy Folder"
		$HomeDeployFolder = $lines[i+1]
		end
		
	if line.include? "Admin Window Service Name"
		$AdminWindowServiceName = $lines[i+1]
		end
		
	if line.include? "MBRDATA Name"
		$MBRDATANAME = $lines[i+1]
		end
		
	if line.include? "Batch Job Task Name"
		$BatchJobTaskName = $lines[i+1]
		end
		
	if line.include? "WebAdmin war Name"
		$WebAdminwarName = $lines[i+1]
		end
		
	if line.include? "Server Name"
		$ServerName = $lines[i+1]
		end	
		
	if line.include? "Server Port"
		$ServerPort = $lines[i+1]
		end	
	
	if line.include? "Context Path Admin"
		$ContextPathAdmin = $lines[i+1]
		end	
	
	if line.include? "Context Path MBRDATA"
		$ContextPathMBRDATA = $lines[i+1]
		end
		
	if line.include? "CAS URL"
		$CASURL = $lines[i+1]
		end
		
	if line.include? "APP URL"
		$APPURL = $lines[i+1]
		end
		
	if line.include? "Database"
		$Database = $lines[i+1]
		end
		
	if line.include? "Logback Admin URL"
		$logbackAdminURL = $lines[i+1]
		end
		
	if line.include? "Logback Batchjob URL"
		$LogbackBatchjobURL = $lines[i+1]
		end
		
	if line.include? "Jboss Deployments Location"
		$JbossDeploymentsLocation = $lines[i+1]
		end
		
	if line.include? "Batch Job Location"
		$BatchJobLocation = $lines[i+1]
		end
	if line.include? "Jboss Home"
		$JbossHome = $lines[i+1]
		end
		
	if line.include? "Domain Name"
		$DomainName = $lines[i+1]
		end
		
	if line.include? "Home Packages Folder"
		$HomePackagesFolder = $lines[i+1]
		end
		
	if line.include? "Quipoz Folder Location"
		$QuipozFolderLocation = $lines[i+1]
		end
		
	if line.include? "Jboss or Wildfly"
		$JbossorWildfly = $lines[i+1]
		end 
		############################# DB.properties ###############################
	if line.include? "Connection dialect"
		$Connectiondialect = $lines[i+1]
		end
		
	if line.include? "Connection Driver"
		$ConnectionDriver = $lines[i+1]
		end
	if line.include? "Connection Url"
		$ConnectionUrl = $lines[i+1]
		end
		
	if line.include? "Connection Username"
		$ConnectionUsername = $lines[i+1]
		end
		
	if line.include? "Connection Password"
		$ConnectionPassword = $lines[i+1]
		end		
}

# d = Time.new
# if (d.wday>=1 && d.wday<=5)
# service "#{$AdminWindowServiceName}" do
	  # supports :status => true
	# timeout 300
	# ignore_failure true
	# end
	
	service "#{$AdminWindowServiceName}" do
	  supports :status => true
    	action :stop
	timeout 300
	ignore_failure true
	end
	
		execute  "end-#{$BatchJobTaskName}-task" do
	  command "schtasks /end /tn \"#{$BatchJobTaskName}\""
	end
	
	powershell_script "stop-#{$BatchJobTaskName}" do
		code <<-EOH
			$a =  Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where CommandLine -match "group" | Where CommandLine -match "#{$BatchJobLocation}"
			If($a -ne $null){
				Invoke-WmiMethod -Path $a.__RELPATH -Name terminate 
			}
		EOH
	end
	powershell_script "stop-#{$AdminWindowServiceName}" do
		code <<-EOH
			$a =  Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where CommandLine -match "group" | Where CommandLine -match "#{$JbossHome}"
			If($a -ne $null){
				Invoke-WmiMethod -Path $a.__RELPATH -Name terminate 
			}
		EOH
	end
if not Dir.exists?("#{$HomeDeployFolder}\\_builds_Admin-Batchjob")
	execute 'create-folder-builds_Admin-Batchjob' do
	  command "mkdir #{$HomeDeployFolder}\\_builds_Admin-Batchjob"
	end
	end	
	
	execute  'get_newBuild' do
	  command "#{$HomeDeployFolder}\\..\\scripts\\download-group-package.bat"
	  action :run
	end
	
	

###################### Backups ##########################
if not Dir.exists?("#{$HomeDeployFolder}\\_backups_Admin-Batchjob")
	execute 'create-folder-backup_Admin-Batchjob' do	
	  command "mkdir #{$HomeDeployFolder}\\_backups_Admin-Batchjob"
	end
	end

	
if not Dir.exists?("#{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp")
	execute 'create-folder-backup_Admin-Batchjob_temp' do		
	  command "mkdir #{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp"
	end
	end

if File.exist?("#{$JbossDeploymentsLocation}\\#{$WebAdminwarName}.war")	
	execute 'copy-AdminWeb-backup' do
	command "mv #{$JbossDeploymentsLocation}\\#{$WebAdminwarName}.war #{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp"
	end
end

if File.exist?("#{$JbossDeploymentsLocation}\\#{$MBRDATANAME}.war")	
	execute 'copy-MBRDATA-backup' do
	command "mv #{$JbossDeploymentsLocation}\\#{$MBRDATANAME}.war #{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp"
	end
end
	
if Dir.exists?("#{$BatchJobLocation}\\csc-smart400-batch")	
	powershell_script 'copy-Batchjob-backup' do
		cwd "#{$BatchJobLocation}"
		code <<-EOH
		mv #{$BatchJobLocation}\\csc-smart400-batch #{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp
	EOH
	end
end	
	execute 'change-folder-backup' do
	  command "ren \"#{$HomeDeployFolder}\\_backups_Admin-Batchjob\\temp\" \"Backup-group-%date:/=-%-%time::=-%\""
	end

######################### Copy Packages #############################################

if not Dir.exists?("#{$HomeDeployFolder}\\admin")
	execute 'create-folder-deploy_Admin' do
	  command "mkdir #{$HomeDeployFolder}\\admin"
	end
	end	
	
	if Dir.exists?("#{$HomeDeployFolder}\\admin")
	powershell_script 'clear_admin_deploy_folder' do
	cwd "#{$HomeDeployFolder}"
	code <<-EOH
	Remove-Item "#{$HomeDeployFolder}\\admin\\*.war" -Force -Recurse -ErrorAction SilentlyContinue
	EOH
	end
	end
	
if not Dir.exists?("#{$HomeDeployFolder}\\batchjob")
	execute 'create-folder-deploy_batchjob' do
	  command "mkdir #{$HomeDeployFolder}\\batchjob"
	end
	end

if Dir.exists?("#{$HomeDeployFolder}\\batchjob")
	powershell_script 'clear_batchjob_deploy_folder' do
	cwd "#{$HomeDeployFolder}"
	code <<-EOH
	Remove-Item "#{$HomeDeployFolder}\\batchjob\\*.zip" -Force -Recurse -ErrorAction SilentlyContinue
	EOH
	end
	end
	
if Dir.exists?("#{$HomeDeployFolder}\\data")
	powershell_script 'clear_data_deploy_folder' do
	cwd "#{$HomeDeployFolder}"
	code <<-EOH
	Remove-Item "#{$HomeDeployFolder}\\data\\*.war" -Force -Recurse -ErrorAction SilentlyContinue
	EOH
	end
	end
	
powershell_script 'Copy_Packages' do
  cwd "#{$HomePackagesFolder}"
  code <<-EOH
  copy #{$WebAdminwarName}.war "#{$HomeDeployFolder}/admin"
  copy csc-smart400-batch.zip "#{$HomeDeployFolder}/batchjob"
  copy MBRDATA.war "#{$HomeDeployFolder}/data"
  EOH
ignore_failure true
end
######################### Config Admin #############################################
	
powershell_script 'config_xml_admin' do
  cwd "#{$HomeDeployFolder}/admin"
  code <<-EOH  
  
  7z d #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/web.xml
  7z d #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/classes/logback.xml
  7z u #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/web.xml
  7z u #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/jboss-deployment-structure.xml
  7z u #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/jboss-web.xml
  7z u #{$HomeDeployFolder}/admin/#{$WebAdminwarName}.war WEB-INF/classes/logback.xml  
  EOH
 end
 
 ######################## Config Batch Job ##########################################
powershell_script 'extract_batchjob' do
  cwd "#{$HomeDeployFolder}/batchjob"
  code <<-EOH
  7z x *.zip -o"#{$HomeDeployFolder}/batchjob" -y 
  EOH
end



powershell_script 'replace_batchjob' do
  cwd "#{$HomeDeployFolder}/batchjob"
  code <<-EOH
  7z a #{$HomeDeployFolder}/batchjob/csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar logback.xml -y
  EOH
end
 
 
 ########################Config MBRDATA ############################################
powershell_script 'config_logback_xml_mbrdata' do
  cwd "#{$HomeDeployFolder}/data"
  code <<-EOH
  
  7z d #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/web.xml
  7z d #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/classes/logback.xml
  7z d #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/classes/config/MBRDATA.properties
  7z a #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/web.xml
  7z a #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/jboss-deployment-structure.xml
  7z a #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/jboss-web.xml
  7z a #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/classes/logback.xml
  7z a #{$HomeDeployFolder}/data/#{$MBRDATANAME}.war WEB-INF/classes/config/MBRDATA.properties
  EOH
end

######################### Copy Packages to deploy #############################################

powershell_script 'Copy_Packages to deploy' do
  cwd "#{$HomeDeployFolder}"
  code <<-EOH
  mv admin/#{$WebAdminwarName}.war "#{$JbossDeploymentsLocation}"
  mv batchjob/csc-smart400-batch "#{$BatchJobLocation}"
  mv data/#{$MBRDATANAME}.war "#{$JbossDeploymentsLocation}"
  EOH

end
######################### Edit Quipoz Version #############################################
if File.exist?("#{$QuipozFolderLocation}\\QuipozCfg.xml")	
powershell_script 'config_QuipozCfg_xml' do
  cwd "#{$QuipozFolderLocation}"
  code <<-EOH
	$YearVersion =  "$(Get-date -f yy.)$("{0:0}" -f [Math]::ceiling((Get-date -f MM)/3) )"
	$MonthDayVersion = (Get-Date).AddDays(-1).ToString('MM.dd')	
	
    [xml]$doc = Get-Content QuipozCfg.xml
	$doc.getElementsByTagName("Version")[0].InnerText = "RC17.2-$MonthDayVersion"
	$doc.getElementsByTagName("FsuVersion")[0].InnerText = "RC17.2-$MonthDayVersion"
	$doc.save("QuipozCfg.xml")
  EOH
  end
  end
######################### Builds Folder #############################################

	if not Dir.exists?("#{$HomeDeployFolder}\\_builds_Admin-Batchjob\\temp")
	execute 'create-folder_builds_Admin-Batchjob_temp' do
   	command "mkdir #{$HomeDeployFolder}\\_builds_Admin-Batchjob\\temp"
	ignore_failure true
	end
	end
	
	powershell_script 'Move_Build-Admin&BatchJob_To_temp' do
  	   cwd "#{$HomeDeployFolder}\\_builds_Admin-Batchjob"
	   code <<-EOH
		mv *.war , *.zip temp
		EOH
	ignore_failure true
	 end
	
	batch 'change-name-temp-folder' do
	cwd "#{$HomeDeployFolder}\\_builds_Admin-Batchjob"
	code <<-EOH
	set year=%date:~-4%
	set month=%date:~-10,2%
	set day=%date:~7,2%
		if "%month%" EQU "01" set month=Jan
		if "%month%" EQU "02" set month=Feb
		if "%month%" EQU "03" set month=Mar
		if "%month%" EQU "04" set month=Apr
		if "%month%" EQU "05" set month=May
		if "%month%" EQU "06" set month=Jun
		if "%month%" EQU "07" set month=Jul
		if "%month%" EQU "08" set month=Aug
		if "%month%" EQU "09" set month=Sep
		if "%month%" EQU "10" set month=Oct
		if "%month%" EQU "11" set month=Nov
		if "%month%" EQU "12" set month=Dec
		
		ren "#{$HomeDeployFolder}\\_builds_Admin-Batchjob\\temp" "Builds-group-%month%-%day%-%year%-%time::=-%"
	EOH
	end

##################################################################################
	if Dir.exists?("#{$JbossHome}\\standalone\\tmp")
	execute 'clear_temp' do
   	command "rd /s /q #{$JbossHome}\\standalone\\tmp"
	end
	end
	
	execute  "start-#{$BatchJobTaskName}-batchjob" do
	  command "schtasks /run /tn \"#{$BatchJobTaskName}\""
	end

	service "#{$AdminWindowServiceName}" do
	  supports :status => true, :restart => true, :start => true
	  action [ :start ]
	timeout 120
	end
# # end