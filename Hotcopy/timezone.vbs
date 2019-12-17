Dim strOffset, strSign, AutoDST


AutoDST = checkAutoDST(".")


for each tz in GetObject("winmgmts:").InstancesOf ("Win32_TimeZone")
  if tz.Bias>=0 then
    strSign = "+"
  else
    strSign = "-"
  end if

  strOffset = right("00" & Abs(tz.Bias\60), 2) & ":" & right("00" & Abs(tz.Bias mod 60), 2)

  if tz.DaylightDay<>0 then
    wscript.Echo "Time Zone: GMT " & strSign & strOffset & AutoDST
  else
    wscript.Echo "Time Zone: GMT " & strSign & strOffset 
  end if
next


' Function to check for auto DST setting.
Private Function checkAutoDST(ByVal strComputer)
Const HKEY_LOCAL_MACHINE = &H80000002
Dim strKeyPath, strValueName, objRegistry, strValue
	strKeyPath = "SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
	strValueName = "DisableAutoDaylightTimeSet"
	Set objRegistry = GetObject("winmgmts:{impersonationLevel=impersonate}//" & _
		  strComputer & "/root/default:StdRegProv")
	objRegistry.GetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,strValue
	If strValue = 1 Then
		checkAutoDST = ""
	Else
		checkAutoDST = " Переход на летнее время"
	End If
Set objRegistry = Nothing
End Function
