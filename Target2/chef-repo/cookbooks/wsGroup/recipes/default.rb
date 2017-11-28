#
# Cookbook Name:: WS-Group
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
	
	if line.include? "WebService Name"
		$WebServiceName = $lines[i+1]
		end		
	
	if line.include? "Axis2"
		$Axis2 = $lines[i+1]
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
		
	if line.include? "WS Builds Folder"
		$WSBuildsFolder = $lines[i+1]
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

	##################download Packages#################
	
	if not Dir.exists?("#{$HomeDeployFolder}\\_builds_WS")
	execute 'create-folder-builds_WS' do
	  command "mkdir #{$HomeDeployFolder}\\_builds_WS"
	end
	end	
	
	execute  'get_newBuild' do
	  command "#{$HomeDeployFolder}\\..\\scripts\\ws-download-package.bat"
	  action :run
	end
	
	########################stop admin##############
	
	service "#{$AdminWindowServiceName}" do
	  supports :status => true
    	action :stop
	timeout 300
	ignore_failure true
	end
	
	powershell_script "stop-#{$AdminWindowServiceName}" do
		code <<-EOH
			$a =  Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where CommandLine -match "group" | Where CommandLine -match "#{$JbossHome}"
			If($a -ne $null){
				Invoke-WmiMethod -Path $a.__RELPATH -Name terminate 
			}
		EOH
	end

###################### Backups ##########################
if not Dir.exists?("#{$HomeDeployFolder}\\_backups_WS")
	execute 'create-folder-backup_WS' do	
	  command "mkdir #{$HomeDeployFolder}\\_backups_WS"
	end
	end

	
if not Dir.exists?("#{$HomeDeployFolder}\\_backups_WS\\temp")
	execute 'create-folder-backup_WS_temp' do		
	  command "mkdir #{$HomeDeployFolder}\\_backups_WS\\temp"
	end
	end

if File.exist?("#{$JbossDeploymentsLocation}\\#{$Axis2}.war")	
	execute 'copy-WS-backup' do
	command "mv #{$JbossDeploymentsLocation}\\#{$Axis2}.war #{$HomeDeployFolder}\\_backups_WS\\temp"
	end
end
	
	execute 'change-folder-backup' do
	  command "ren \"#{$HomeDeployFolder}\\_backups_WS\\temp\" \"Backup-WS-Group%date:/=-%-%time::=-%\""
	end

######################### Copy Packages #############################################

if not Dir.exists?("#{$HomeDeployFolder}\\ws")
	execute 'create-folder-deploy_ws' do
	  command "mkdir #{$HomeDeployFolder}\\ws"
	end
	end	
	
	if Dir.exists?("#{$HomeDeployFolder}\\ws")
	powershell_script 'clear_ws_deploy_folder' do
	cwd "#{$HomeDeployFolder}"
	code <<-EOH
	Remove-Item "#{$HomeDeployFolder}\\ws\\WEB-INF\\services\\*.aar" -Force -Recurse -ErrorAction SilentlyContinue
	EOH
	end
	end
	
powershell_script 'Copy_Packages' do
  cwd "#{$WSBuildsFolder}"
  code <<-EOH
  copy #{$WebServiceName}.aar "#{$HomeDeployFolder}/ws/WEB-INF/services"
  EOH
ignore_failure true
end
######################### Config Admin #############################################
	
powershell_script 'config_xml_webservice' do
  cwd "#{$HomeDeployFolder}/ws/WEB-INF/services"
  code <<-EOH  
  7z d #{$HomeDeployFolder}/ws/WEB-INF/services/#{$WebServiceName}.aar logback.xml
  7z u #{$HomeDeployFolder}/ws/WEB-INF/services/#{$WebServiceName}.aar logback.xml
  EOH
  end

powershell_script 'config_xml_webservice' do
  cwd "#{$HomeDeployFolder}/ws"
  code <<-EOH  
  7z d #{$HomeDeployFolder}/ws/#{$Axis2}.war WEB-INF/services/GroupServices.aar
  7z u #{$HomeDeployFolder}/ws/#{$Axis2}.war WEB-INF/services/GroupServices.aar
  EOH
  end  

######################### Copy Axis2 to deploy #############################################

powershell_script 'Copy Axis2 to deploy' do
  cwd "#{$HomeDeployFolder}"
  code <<-EOH
  cp ws/#{$Axis2}.war "#{$JbossDeploymentsLocation}"
  EOH
end

######################### Builds Folder #############################################

	if not Dir.exists?("#{$HomeDeployFolder}\\_builds_WS\\temp")
	execute 'create-folder_builds_WS_temp' do
   	command "mkdir #{$HomeDeployFolder}\\_builds_WS\\temp"
	ignore_failure true
	end
	end
	
	powershell_script 'Move_builds_WS_To_temp' do
  	   cwd "#{$HomeDeployFolder}\\_builds_WS"
	   code <<-EOH
		mv *.aar , *.zip temp
		EOH
	ignore_failure true
	 end
	
	batch 'change-name-temp-folder' do
	cwd "#{$HomeDeployFolder}\\_builds_WS"
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
		
		ren "#{$HomeDeployFolder}\\_builds_WS\\temp" "Builds-WS-Group-%month%-%day%-%year%-%time::=-%"
	EOH
	end

##################################################################################
	if Dir.exists?("#{$JbossHome}\\standalone\\tmp")
	execute 'clear_temp' do
   	command "rd /s /q #{$JbossHome}\\standalone\\tmp"
	end
	end

	service "#{$AdminWindowServiceName}" do
	  supports :status => true, :restart => true, :start => true
	  action [ :start ]
	timeout 120
	end
# # end
