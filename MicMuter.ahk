#Include SoundLibrary.ahk

OnExit("ExitFunc")
bool := False
device := VA_GetDevice("capture")
Send, {F6}
Sleep, 100
Send, {F6}

F6::RecordingDeviceState(device, bool := !bool)
 
RecordingDeviceState(device_desc, bool := False){
	; CPolicyConfigClient
	Static CLSID := "{870af99c-171d-4f9e-af0d-e63df40c2bc9}"
	; IPolicyConfig
	Static IID   := "{f8679f50-850a-41cf-9c72-430f290290c8}"
	if(PolConfig := ComObjCreate(CLSID, IID)) {
		if(defRecordingDevice := VA_GetDevice(device_desc)) { ; get default playback device
			if(VA_IMMDevice_GetId(defRecordingDevice, id) == 0){ ; get the device id
				DllCall(NumGet(NumGet(PolConfig+0)+14*A_PtrSize), "Ptr", PolConfig, "WStr", id, "Int", bool) ; ::SetEndpointVisibility - disable the device
				GoSub, ToggleIcon
			}
			ObjRelease(defRecordingDevice) ; cleanup
		}
		ObjRelease(PolConfig)
	}
}

ExitFunc(ExitReason, ExitCode){
	Global device
	RecordingDeviceState(device, True)
	ObjRelease(device)
}

ToggleIcon:
if bool {
	Menu, Tray, Icon, MicOn.png	
} else {
	Menu, Tray, Icon, MicOff.png
}
return
