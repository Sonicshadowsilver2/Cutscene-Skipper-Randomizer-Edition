local GameVersion = 0
local canExecute = false

function _OnInit()
    GameVersion = 0
end

function GetVersion() --Define anchor addresses
    if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
        if ReadString(0x09A70B0 - 0x56454E,4) == 'KH2J' then --EGS v1.0.0.8
            GameVersion = 1
            print('Epic Version 1.0.0.8_WW Detected - Cutscene Skipper')
            Now = 0x0714DB8 - 0x56454E --Current Location
            Save = 0x09A70B0 - 0x56454E --Save File
            CutNow = 0x0B62798 - 0x56454E --Cutscene Timer
            CutLen = 0x0B627B4 - 0x56454E --Cutscene Length
            CutSkp = 0x0B6279C - 0x56454E --Cutscene Skip
            Cntrl = 0x2A148A8 - 0x56450E --Sora Controllable
            Load = 0xAB8C78 - 0x56450E
            canExecute = true
        elseif ReadString(0x09A92F0,4) == 'KH2J' then --EGS v1.0.0.9
            GameVersion = 2
            print('Epic Version 1.0.0.9_WW Detected - Cutscene Skipper')
            Now = 0x0716DF8 --Current Location
            Save = 0x09A92F0 --Save File
            CutNow = 0x0B649D8 --Cutscene Timer
            CutLen = 0x0B649F4 --Cutscene Length
            CutSkp = 0x0B649DC --Cutscene Skip
            Cntrl = 0x2A16C28 --Sora Controllable
            Load = 0x0ABAEF8
            canExecute = true
        elseif ReadString(0x09A9330,4) == 'KH2J' then --EGS v1.0.0.10
            GameVersion = 3
            print('Epic Version 1.0.0.10_WW Detected - Cutscene Skipper')
            Now = 0x0716DF8 --Current Location
            Save = 0x09A9330 --Save File
            CutNow = 0x0B64A18 --Cutscene Timer
            CutLen = 0x0B64A34 --Cutscene Length
            CutSkp = 0x0B64A1C --Cutscene Skip
            Cntrl = 0x2A16C68 --Sora Controllable
            Load = 0x0ABAF38
            canExecute = true
        elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam GL v1.0.0.1
            GameVersion = 4
            print('Steam GL v1.0.0.1 Detected - Cutscene Skipper')
            Now = 0x0717008 --Current Location
            Save = 0x09A9830 --Save File
            CutNow = 0x0B64F18 --Cutscene Timer
            CutLen = 0x0B64F34 --Cutscene Length
            CutSkp = 0x0B64F1C --Cutscene Skip
            Cntrl = 0x2A17168 --Sora Controllable
            Load = 0x0ABB438
            canExecute = true
        elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP v1.0.0.1
            GameVersion = 5
            print('Steam JP v1.0.0.1 Detected - Cutscene Skipper')
            Now = 0x0716008 --Current Location
            Save = 0x09A8830 --Save File
            CutNow = 0x0B63F18 --Cutscene Timer
            CutLen = 0x0B63F34 --Cutscene Length
            CutSkp = 0x0B63F1C --Cutscene Skip
            Cntrl = 0x2A16168 --Sora Controllable
            Load = 0x0ABA438
            canExecute = true
        elseif ReadString(0x09A98B0,4) == 'KH2J' then --Steam v1.0.0.2
            GameVersion = 6
            print('Steam v1.0.0.2 Detected - Cutscene Skipper')
            Now  = 0x0717008 --Current Location
            Save = 0x09A98B0 --Save File
            CutNow = 0x0B64F98 --Cutscene Timer
            CutLen = 0x0B64FB4 --Cutscene Length
            CutSkp = 0x0B64F9C --Cutscene Skip
            Cntrl = 0x2A171E8 --Sora Controllable
            Load = 0x0ABB4B8
            canExecute = true
        end
    end
end

function BitOr(Address,Bit,Abs)
WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
    
function BitNot(Address,Bit,Abs)
WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

function _OnFrame()
    if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end
	if ReadShort(Now+0x00) == 0x1A04 then --Garden of Assemblage
        if ReadShort(CutLen) == 0x01E3 then --GoA Computer Cutscene
            WriteByte(CutSkp, 0x01)
        end
        if ReadByte(Save+0x1DB1) == 0x0F and ReadByte(Save+0x1DB7) == 0x7F then --Post A Blustery Rescue
            WriteByte(Save+0xDAC, 0x14)
            BitOr(Save+0x1DB1, 0xC0)
            if ReadByte(Save+0x1DB2) == 0x00 then --Rabbit's House not accessible
                WriteByte(Save+0xD90, 0x05)
            end
        end
        if ReadByte(Save+0x1DB2) == 0x0F and ReadByte(Save+0x1DB6) == 0x38 then --Post Hunny Slider
            WriteByte(Save+0xDA6, 0x12)
            BitOr(Save+0x1DB2, 0xC0)
            if ReadByte(Save+0x1DB3) == 0x00 then --Kanga's House not accessible
                WriteByte(Save+0xD90, 0x08)
            end
        end
        if ReadByte(Save+0x1DB3) == 0x0F and ReadByte(Save+0x1DB6) == 0x78 then --Post Balloon Bounce
            WriteByte(Save+0xDB2, 0x10)
            BitOr(Save+0x1DB3, 0xC0)
            if ReadByte(Save+0x1DB4) == 0x00 then --The Spooky Cave not accessible
                WriteByte(Save+0xD90, 0x0B)
            end
        end
    end
    if ReadShort(Now+0x00) == 0x0312 and ReadShort(CutLen) == 0x0514 then --Pre-Roxas Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x1512 and ReadShort(CutLen) == 0x0B97 then --Post Roxas Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1B92, 0x00)
        BitOr(Save+0x1ED0, 0x80)
    end
    if ReadShort(Now+0x00) == 0x0412 and ReadByte(Save+0x1ED1) == 0x12 then --Pre-Enter Castle Cutscene
		WriteByte(Save+0x1ED1, 0x1E)
        WriteByte(Save+0x1EDF, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0612 and ReadByte(Save+0x1ED1) == 0x3E then --Enter Castle Cutscene
        WriteByte(Save+0x1B28, 0x00)
        WriteByte(Save+0x1B2C, 0x15)
        WriteByte(Save+0x1B46, 0x01)
        WriteByte(Save+0x1B4A, 0x16)
        WriteByte(Save+0x1B50, 0x01)
        WriteByte(Save+0x1B74, 0x00)
        BitOr(Save+0x1ED1, 0x40)
        WriteByte(Save+0x1EDF, 0x02)
	end
    if ReadShort(Now+0x00) == 0x0A12 and ReadShort(Save+0x1ED1) == 0x027E then --Pre-Xigbar Cutscene
        WriteShort(Save+0x1ED1, 0x03FE)
	end
    if ReadShort(Now+0x00) == 0x0A12 and ReadShort(CutLen) == 0x0755 then --Post Xigbar Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0C12 and ReadShort(CutLen) == 0x1E4C then --Pre-Reunion Cutscene
		WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1B5C, 0x00)
        WriteByte(Save+0x1B80, 0x00)
        BitOr(Save+0x1ED2, 0x08)
	end
    if ReadInt(Now+0x00) == 0x00320D12 and ReadByte(Save+0x1EDF) == 0x02 then --Post Reunion Cutscene
		WriteByte(Save+0x1EDF, 0x03)
	end
    if ReadShort(Now+0x00) == 0x0E12 and ReadShort(CutLen) == 0x0492 then --Post Luxord Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0F12 and ReadShort(CutLen) == 0x0AA2 then --Post Saix Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadByte(Save+0x1B5E) == 0x04 and ReadByte(Save+0x1B62) == 0x14 then --Path to Xemnas Cutscene
        if ReadByte(Save+0x35C1) >= 0x02 then
            WriteByte(Save+0x1B5E, 0x00)
        end
    end
    if ReadShort(Now+0x00) == 0x0D12 and ReadShort(CutLen) == 0x008C then --Riku Joins Party Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Now+0x01, 0x10)
        WriteByte(Save+0x1B5E, 0x03)
        WriteByte(Save+0x1B62, 0x13)
        WriteInt(Save+0x1B72, 0x00000001)
        WriteInt(Save+0x1B78, 0x00010001)
        BitOr(Save+0x1ED3, 0x60)
        BitOr(Save+0x1ED8, 0x10)
        WriteByte(Save+0x1EDF, 0x04)
	end
    if ReadShort(Now+0x00) == 0x1312 and ReadByte(Save+0x1ED4) == 0x06 then --Pre-Xemnas Cutscene
        BitOr(Save+0x1ED4, 0x08)
	end
    if ReadShort(Now+0x00) == 0x1312 and ReadShort(CutLen) == 0x02C6 then --Post Xemnas Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1ED4, 0x10)
        WriteByte(Save+0x1EDE, 0x05)
	end
    if ReadShort(Now+0x00) == 0x1B12 and ReadByte(Save+0x1ED4) == 0x7E then --Entering Final Battles Cutscene
        BitOr(Save+0x1ED4, 0x80)
        WriteByte(Save+0x1B8C, 0x00)
	end
    if ReadShort(Now+0x00) == 0x2102 and ReadByte(Save+0x1ED4) > 0x7F then --Entering Final Battles Cutscene (Promise Charm)
        WriteShort(Now+0x00, 0x1B12)
	end
    if ReadShort(Now+0x00) == 0x1712 and ReadByte(Now+0x08) == 0x49 then --Armor Xemnas II Auto-Revert/Refill
        if ReadShort(Now+0x30) == 0x1812 and ReadByte(Now+0x38) == 0x47 then
            WriteInt(Save+0x2524,ReadInt(Save+0x2534)) --Auto-Reload Item Slots 1 & 2
            WriteInt(Save+0x2528,ReadInt(Save+0x2538)) --Auto-Reload Item Slots 3 & 4
            WriteInt(Save+0x252C,ReadInt(Save+0x253C)) --Auto-Reload Item Slots 5 & 6
            WriteInt(Save+0x2530,ReadInt(Save+0x2540)) --Auto-Reload Item Slots 7 & 8
        end
    end
    if ReadShort(Now+0x00) == 0x1412 and ReadByte(Now+0x08) == 0x4A then --Final Xemnas Auto-Refill
        if ReadShort(Now+0x30) == 0x1712 and ReadByte(Now+0x38) == 0x49 then
            WriteInt(Save+0x2524,ReadInt(Save+0x2534)) --Auto-Reload Item Slots 1 & 2
            WriteInt(Save+0x2528,ReadInt(Save+0x2538)) --Auto-Reload Item Slots 3 & 4
            WriteInt(Save+0x252C,ReadInt(Save+0x253C)) --Auto-Reload Item Slots 5 & 6
            WriteInt(Save+0x2530,ReadInt(Save+0x2540)) --Auto-Reload Item Slots 7 & 8
        end
    end
    if ReadShort(Now+0x00) == 0x1412 and ReadShort(CutLen) == 0x00DC then --Post Data Final Xemnas Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0008 and ReadByte(Save+0x1D91) == 0x05 then --The Land of Dragons 1 1st Cutscene
        WriteByte(Save+0xC10, 0x00)
        WriteByte(Save+0xC1A, 0x01)
        BitOr(Save+0x1D91, 0x02)
        BitOr(Save+0x1D94, 0x10)
        WriteShort(Save+0x1FA2, 0x8581)
        WriteShort(Save+0x3555, 0x0201)
    end
    if ReadShort(Now+0x00) == 0x0108 then --Encampment Cutscenes
        if ReadShort(CutLen) == 0x062C or ReadShort(CutLen) == 0x0087 then
            if ReadShort(CutNow) == 0x0001 then --Post Encampment Heartless & Mission 3 Cutscenes
                WriteByte(CutSkp, 0x01)
            end
        end
	end
    if ReadShort(Now+0x00) == 0x0308 and ReadShort(CutLen+0x00) == 0x0276 then --Pre-Mountain Trail Cutscene
		WriteByte(CutSkp+0x00, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0308 and ReadShort(CutLen) == 0x05ED then --Post Mountain Trail Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D96, 0x20)
	end
    if ReadShort(Now+0x00) == 0x0608 and ReadShort(Save+0x3555) == 0x1212 then --Pre-Summit Heartless Cutscene
        WriteByte(Now+0x01, 0x07)
    end
    if ReadShort(Now+0x00) == 0x0808 and ReadShort(CutLen) == 0x08AC then --Pre-Imperial Square Heartless 1 Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0908 and ReadShort(CutLen) == 0x0542 then --Pre-Shan-Yu Cutscene (if Shan-Yu Skip is disabled)
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0908 and ReadShort(CutLen) == 0x1C42 then --Post Shan-Yu Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1D9F, 0x04)
    end
    if ReadShort(Now+0x00) == 0x0708 and ReadShort(CutLen) == 0x0A00 then --Pre-Riku Fight Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0708 and ReadShort(CutLen) == 0x0A62 then --Post Riku Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0xC3C, 0x0A)
        BitOr(Save+0x1D92, 0x80)
        BitOr(Save+0x1D98, 0x04)
        WriteByte(Save+0x1D9F, 0x06)
    end
    if ReadShort(Now+0x00) == 0x0908 and ReadByte(Save+0x1D98) == 0x17 then --Post Imperial Square Heartless 2 Cutscene
        BitOr(Save+0x1D98, 0x08)
	end
    if ReadInt(Now+0x00) == 0x00320A08 and ReadByte(Save+0x1D98) == 0x5F then --Pre-Antechamber Nobodies Cutscene
        WriteByte(Save+0xC42, 0x0A)
        WriteInt(Save+0xC48, 0x0000000A)
        BitOr(Save+0x1D98, 0x20)
    end
    if ReadInt(Now+0x00) == 0x00320B08 and ReadByte(Save+0x1D93) == 0x0B then --Post Antechamber Nobodies Cutscene
        WriteByte(Save+0xC18, 0x0C)
        WriteByte(Save+0xC1E, 0x0C)
        WriteByte(Save+0xC24, 0x0C)
        WriteByte(Save+0xC30, 0x0C)
        WriteByte(Save+0xC36, 0x0C)
        WriteByte(Save+0xC3C, 0x0B)
        BitOr(Save+0x1D93, 0x40)
        WriteByte(Save+0x1D9F, 0x07)
    end
    if ReadShort(Now+0x00) == 0x0808 and ReadByte(Save+0x0C50) == 0x0D then --Pre-Storm Rider Cutscene
        WriteByte(Save+0xC50, 0x00)
        BitOr(Save+0x1D94, 0x01)
        WriteShort(Save+0x1FAC, 0x0000)
    end
    if ReadByte(Save+0x1D94) == 0x79 or ReadByte(Save+0x1D94) == 0x7B then --Post Storm Rider Cutscene
        BitOr(Save+0x1D94, 0x04)
        WriteShort(Save+0x1D9E, 0x0802)
    end
    if ReadShort(Now+0x00) == 0x0A12 and ReadShort(CutLen) == 0x00DC then --Post Data Xigbar Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0005 and ReadByte(Now+0x08) == 0x01 then --Beast's Castle 1 1st Cutscene
        WriteArray(Now+0x01, {0x01, 0x00, 0x00, 0x44, 0x00, 0x44, 0x00, 0x44})
        WriteByte(Save+0x0D, 0x01)
        WriteInt(Save+0x794, 0x00010000)
        BitOr(Save+0x1D30, 0x06)
        BitOr(Save+0x1D31, 0x20)
        WriteByte(Save+0x1D3F, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0B05 and ReadShort(CutLen) == 0x0492 then --Pre-Thresholder Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0C05 and ReadShort(CutLen) == 0x064C then --Secret Passage 1st Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0305 and ReadByte(Save+0x1D3F) == 0x04 then  --Pre-Beast Cutscene
        WriteByte(Save+0x1D3F, 0x05)
    end
    if ReadShort(Now+0x00) == 0x0305 and ReadShort(CutLen+0x00) == 0x08DA or ReadShort(CutLen) == 0x07EE then
		WriteByte(CutSkp+0x00, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0405 and ReadShort(CutLen) == 0x0494 then  --Pre-Shadow Stalker Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0505 and ReadShort(CutLen) == 0x02DA then  --Post Shadow Stalker Cutscene (Boss/Enemy)
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0505 and ReadShort(CutLen) == 0x0258 then --Post Dark Thorn Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D30, 0x40)
        WriteByte(Save+0x1D3F, 0x07)
	end
    if ReadShort(Now+0x00) == 0x0205 and ReadByte(Now+0x08) == 0x0A then --Start of 2nd Visit
        WriteShort(Now+0x01, 0x3300)
        WriteByte(Now+0x08, 0x0B)
        WriteShort(Save+0x0D, 0x3300)
        WriteByte(Save+0x794, 0x0B)
        WriteByte(Save+0x79A, 0x10)
        WriteInt(Save+0x7B4, 0x000A0001)
        WriteByte(Save+0x7BC, 0x0A)
        WriteByte(Save+0x7C2, 0x0A)
        WriteByte(Save+0x7C8, 0x0A)
        WriteByte(Save+0x7D4, 0x0A)
        WriteByte(Save+0x7DA, 0x0A)
        BitOr(Save+0x1D32, 0x02)
        BitOr(Save+0x1D33, 0x02)
        BitOr(Save+0x1D38, 0x08)
        WriteByte(Save+0x1D3F, 0x09)
        WriteInt(Save+0x1FCC, 0x85448543)
        WriteArray(Save+0x20BC, {0x41, 0x85, 0x42, 0x85, 0x3B, 0x85, 0x3C, 0x85, 0x3D, 0x85, 0x3E, 0x85, 0x3F, 0x85, 0x40, 0x85})
	end
    if ReadShort(Now+0x00) == 0x0005 and ReadByte(Save+0x1D33) == 0x23 and ReadByte(Save+0x3549) == 0x03 then --Pre-Ballroom Nodbodies Cutscene
        WriteByte(Now+0x01, 0x04)
        WriteByte(Save+0x794, 0x00)
        WriteByte(Save+0x7A0, 0x00)
        BitOr(Save+0x1D33, 0x10)
	end
    if ReadInt(Now+0x00) == 0x00320905 and ReadByte(Save+0x1D33) == 0x33 then --Before Rumbling Rose Cutscene
        WriteInt(Save+0x7AA, 0x0000000A)
        BitOr(Save+0x1D33, 0x80)
    end
    if ReadShort(Now+0x00) == 0x0005 and ReadShort(CutLen) == 0x048D then --Pre-Entrance Hall Nobodies Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0605 and ReadShort(CutLen) == 0x05ED then --Pre-Xaldin Cutscene
		WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x79C, 0x00)
        WriteByte(Save+0x7B8, 0x00)
        BitOr(Save+0x1D34, 0x20)
	end
    if ReadShort(Now+0x00) == 0x0F05 and ReadShort(CutLen) == 0x0277 then --Post Xaldin Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
            BitOr(Save+0x1D31, 0x04)
            WriteByte(Save+0x1D3E, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0F05 and ReadShort(CutLen) == 0x00DC then --Post Data Xaldin Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x040E and ReadByte(Now+0x08) == 0x01 then --Halloween Town 1 1st Cutscene
        WriteArray(Now+0x01, {0x02, 0x32, 0x00, 0x05, 0x00, 0x00, 0x00, 0x15})
        WriteShort(Save+0x0D, 0x3202)
        WriteByte(Save+0x1514, 0x01)
        WriteByte(Save+0x151C, 0x05)
        WriteByte(Save+0x1520, 0x15)
        WriteInt(Save+0x152C, 0x00)
        WriteByte(Save+0x1530, 0x14)
        BitOr(Save+0x1E50, 0x04)
        BitOr(Save+0x1E53, 0x10)
        BitOr(Save+0x1E57, 0x02)
        WriteInt(Save+0x2014, 0x858B858A)
    end
    if ReadShort(Now+0x00) == 0x020E and ReadByte(Save+0x1E5F) == 0x00 and ReadByte(Save+0x356D) == 0x03 then --After Jack Reunion Cutscene
		WriteByte(Now+0x01, 0x01)
        WriteByte(Save+0x1510, 0x00)
        WriteByte(Save+0x151C, 0x01)
        WriteByte(Save+0x1520, 0x00)
        BitOr(Save+0x1E50, 0x08)
        WriteByte(Save+0x1E5F, 0x01)
        WriteShort(Save+0x201A, 0x8589)
	end
    if ReadShort(Now+0x00) == 0x000E and ReadShort(CutLen) == 0x02F4 then --Pre-HT Square Heartless Cutscene
        WriteByte(CutSkp, 0x01)
    end
    --[[if ReadInt(Now+0x00) == 0x0033000E then --Post HT Square Heartless Cutscene
        BitOr(Save+0x1E50, 0xC0)
    end]]
    if ReadShort(Now+0x00) == 0x050E and ReadByte(Save+0x1E5F) == 0x01 then --Before Candy Cane Lane Heartless
        WriteByte(Save+0x152C, 0x00)
        BitOr(Save+0x1E51, 0x02)
        WriteByte(Save+0x1E5F, 0x02)
	end
    if ReadShort(Now+0x00) == 0x060E and ReadShort(CutLen) == 0x0253 then --Pre-Candy Cane Lane Heartless Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x0033060E and ReadByte(Save+0x1E5F) == 0x03 then --Before Prison Keeper
        WriteByte(Save+0x154A, 0x00)
        BitOr(Save+0x1E51, 0x40)
        WriteByte(Save+0x1E5F, 0x04)
    end
    if ReadInt(Now+0x00) == 0x0034020E and ReadByte(Save+0x1E5F) == 0x04 then --After Prison Keeper
        WriteByte(Save+0x1528, 0x00)
        WriteByte(Save+0x1534, 0x03)
        WriteByte(Save+0x1540, 0x00)
        BitOr(Save+0x1E52, 0x18)
        WriteByte(Save+0x1E5F, 0x05)
        WriteShort(Save+0x2020, 0x0000)
    end
    if ReadInt(Now+0x00) == 0x0032050E and ReadByte(Save+0x1E5F) == 0x05 then --Before Oogie Boogie
        WriteArray(Save+0x151A, {0x00, 0x00, 0x00, 0x00, 0x02})
        WriteByte(Save+0x1520, 0x00)
        WriteByte(Save+0x152C, 0x00)
        BitOr(Save+0x1E52, 0x40)
        WriteByte(Save+0x1E5F, 0x06)
    end
    if ReadShort(Now+0x00) == 0x090E then--Toy Factory: Shipping and Receiving Cutscenes
        if ReadShort(CutLen) == 0x0DD4 then --Pre-Oogie Boogie Cutscene
            WriteByte(CutSkp, 0x01)
        end
        if ReadShort(CutLen) == 0x03B3 then --Post Oogie Boogie Cutscene
            WriteByte(CutSkp, 0x01)
            BitOr(Save+0x1E53, 0x02)
            WriteByte(Save+0x1E5F, 0x07)
        end
    end
    if ReadShort(Now+0x00) == 0x010E and ReadByte(Save+0x1E5F) == 0x08 and ReadByte(Save+0x356D) == 0x03 then --Start of 2nd Visit Cutscene
        if ReadByte(Cntrl) == 0x00 then
            WriteByte(Now+0x01, 0x04)
            WriteByte(Save+0x1512, 0x0A)
            WriteByte(Save+0x151A, 0x0F)
            WriteByte(Save+0x151E, 0x0A)
            WriteByte(Save+0x1524, 0x0A)
            WriteByte(Save+0x152A, 0x0A)
            WriteByte(Save+0x1532, 0x14)
            WriteByte(Save+0x1536, 0x0A)
            BitOr(Save+0x1E51, 0x10)
            BitOr(Save+0x1E54, 0x02)
            BitOr(Save+0x1E56, 0x40)
            WriteByte(Save+0x1E5F, 0x09)
            WriteInt(Save+0x200C, 0x85938592)
        end
	end
    if ReadShort(Now+0x00) == 0x0A0E and ReadShort(CutLen) == 0x03C5 then --Pre-Lock/Shock/Barrel Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x0034080E and ReadByte(Save+0x1E54) == 0xAA then --Post Lock/Shock/Barrel Cutscene
        BitOr(Save+0x1E54, 0x40)
    end
    if ReadShort(Now+0x00) == 0x000E and ReadShort(CutLen) == 0x0465 then --Post Present Collection Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1512, 0x0B)
        WriteByte(Save+0x1516, 0x01)
        WriteByte(Save+0x151A, 0x14)
        WriteByte(Save+0x151E, 0x0B)
        WriteByte(Save+0x152A, 0x0B)
        WriteByte(Save+0x152E, 0x00)
        WriteByte(Save+0x1532, 0x15)
        WriteByte(Save+0x1536, 0x0B)
        BitOr(Save+0x1E55, 0x06)
    end
    if ReadShort(Now+0x00) == 0x0A0E and ReadShort(CutLen) == 0x0149 then --Post Gift Wrapping Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1E55, 0x10)
    end
    if ReadShort(Now+0x00) == 0x070E and ReadShort(CutLen) == 0x0908 then --Post Experiment Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1E56, 0x05)
        WriteShort(Save+0x1E5E, 0x0C02)
	end
    if ReadShort(Now+0x00) == 0x2004 then --Vexen Cutscenes
        if ReadShort(CutLen) == 0x0140 or ReadShort(CutLen) == 0x00DC then --Post Vexen Cutscenes
            if ReadShort(CutNow) >= 0x0002 then
                WriteByte(CutSkp, 0x01)
            end
        end
	end
    if ReadShort(Now+0x00) == 0x0007 and ReadByte(Now+0x08) == 0x01 then --Pre-Agrabah Heartless Cutscene
        WriteArray(Now+0x02, {0x00, 0x00, 0x39, 0x00, 0x39, 0x00, 0x39})
        WriteByte(Save+0x0E, 0x00)
        WriteByte(Save+0xA94, 0x00)
        BitOr(Save+0x1D73, 0x08)
        BitOr(Save+0x1D74, 0x08)
        WriteByte(Save+0x1D7F, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0007 and ReadShort(CutLen) == 0x0333 then --Post Agrabah Heartless Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D70, 0x04)
    end
    if ReadShort(Now+0x00) == 0x0007 and ReadByte(Save+0x1D7F) == 0x01 and ReadByte(Save+0x3551) == 0x03 then --Jasmine Reunion Cutscene
        WriteByte(Save+0xA90, 0x00)
        WriteByte(Save+0xA9C, 0x00)
        WriteByte(Save+0xAA6, 0x00)
        BitOr(Save+0x1D74, 0x60)
        WriteByte(Save+0x1D7F, 0x02)
        WriteShort(Save+0x1F7A, 0x827D)
        BitOr(Save+0x2330, 0x08)
    end
    if ReadInt(Now+0x00) == 0x00320907 and ReadByte(Save+0x1D7F) == 0x02 then --Post Abu Escort Cutscene
        WriteByte(Save+0xADE, 0x01)
        WriteByte(Save+0xAE2, 0x01)
        BitOr(Save+0x1D75, 0x10)
        WriteByte(Save+0x1D7F, 0x03)
	end
    if ReadInt(Now+0x00) == 0x00320007 and ReadByte(Save+0x1D7F) == 0x04 then --Before Lords Cutscene
        WriteByte(Save+0xA98, 0x02)
        WriteByte(Save+0xA9C, 0x02)
        WriteByte(Save+0xAA0, 0x13)
        WriteByte(Save+0xAB8, 0x11)
        WriteByte(Save+0xABC, 0x02)
        WriteByte(Save+0xAD0, 0x00)
        WriteByte(Save+0xADA, 0x02)
        BitOr(Save+0x1D72, 0x02)
        BitOr(Save+0x1D75, 0x80)
        WriteByte(Save+0x1D7F, 0x05)
	end
    if ReadShort(Now+0x00) == 0x0307 and ReadShort(CutLen) == 0x129A then --Pre-Lords Cutscenes
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0307 and ReadShort(CutLen) == 0x03A6 then --Post Lords Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D72, 0x0C)
        WriteByte(Save+0x1D7F, 0x06)
    end
    if ReadShort(Now+0x00) == 0x0407 and ReadByte(Save+0xAAC) == 0x0A and ReadByte(Save+0x3551) == 0x03 then --Agrabah 2 1st Cutscene
        if ReadByte(Cntrl) == 0x00 then
            WriteByte(Now+0x01, 0x0F)
            WriteByte(Save+0xAAC, 0x00)
            BitOr(Save+0x1D72, 0x40)
            BitOr(Save+0x1D73, 0x40)
        end
    end
    if ReadShort(Now+0x00) == 0x0E07 then --Sandswept Ruins Cutscenes
        if ReadShort(CutLen) == 0x03D6 then --Start of Sandswept Ruins Cutscene
            WriteByte(CutSkp, 0x01)
        end
        if ReadByte(Now+0x08) == 0x56 and ReadByte(Save+0x1D70) == 0x4D then --Sandswept Ruins Heartless 1
            WriteByte(Save+0xAE6, 0x00)
            BitOr(Save+0x1D70, 0x02)
        end
        if ReadByte(Now+0x02) == 0x33 and ReadByte(Save+0x1D70) == 0xCF then --Post Sandswept Ruins Heartless 1
            BitOr(Save+0x1D70, 0x30)
        end
        if ReadByte(Now+0x08) == 0x57 and ReadByte(Save+0x1D71) == 0x1A then --Sandswept Ruins Heartless 2
            WriteByte(Save+0xAE6, 0x00)
            BitOr(Save+0x1D71, 0x04)
        end
	end
    if ReadShort(Now+0x00) == 0x0B07 and ReadShort(CutLen) == 0x098B then --Pre-Carpet Escape Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x00360007 and ReadByte(Save+0x1D74) == 0x78 then --Peddler Cutscene
        WriteByte(Save+0xAA0, 0x16)
        BitOr(Save+0x1D74, 0x80)
    end
    if ReadShort(Now+0x00) == 0x0507 and ReadByte(Save+0x1D73) == 0x7E then --Pre-Genie Jafar Cutscene before Peddler
        WriteByte(Save+0xA96, 0x00)
        BitOr(Save+0x1D73, 0x80)
    end
    if ReadShort(Now+0x00) == 0x0307 and ReadShort(CutLen) == 0x0963 then --Pre-Genie Jafar Cutscene after Peddler
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0xA96, 0x00)
        BitOr(Save+0x1D73, 0x80)
    end
    if ReadShort(Now+0x00) == 0x0507 and ReadShort(CutLen) == 0x094E then --Post Genie Jafar Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D77, 0x08)
        WriteByte(Save+0x1D7E, 0x02)
        BitOr(Save+0x1E71, 0x80)
	end
    if ReadShort(Now+0x00) == 0x2104 then --Lexaeus & Larxene Cutscenes
        if ReadShort(CutLen) == 0x0139 or ReadShort(CutLen) == 0x00DC or ReadShort(CutLen) == 0x0104 or ReadShort(CutLen) == 0x00DB then
            if ReadShort(CutNow) >= 0x0002 then --Post Lexaeus & Larxene Cutscenes
                WriteByte(CutSkp, 0x01)
            end
        end
	end
    if ReadShort(Now+0x00) == 0x0006 and ReadByte(Now+0x08) == 0x01 then --Olympus Coliseum 1 1st Cutscene
        WriteArray(Now+0x01, {0x03, 0x32, 0x00, 0x01, 0x00, 0x16, 0x00, 0x02})
        WriteByte(Save+0x0D, 0x3203)
        WriteByte(Save+0x914, 0x00)
        WriteByte(Save+0x926, 0x02)
        BitOr(Save+0x1D50, 0x02)
        BitOr(Save+0x1D54, 0x01)
        BitOr(Save+0x1D56, 0x08)
        WriteByte(Save+0x1D6F, 0x01)
        WriteArray(Save+0x1F04, {0x98, 0x82, 0x99, 0x82, 0x9A, 0x82, 0x9B, 0x82})
        WriteInt(Save+0x1F38, 0xC13EC13D)
    end
    if ReadInt(Now+0x00) == 0x00320506 and ReadByte(Save+0x1D50) == 0x13 then --Before Hades Escape Cutscene
        WriteByte(Save+0x950, 0x00)
        BitOr(Save+0x1D50, 0x40)
    end
    if ReadShort(Now+0x00) == 0x0606 then --Hades' Chamber Cutscenes
        if ReadShort(CutLen) == 0x0C6C or ReadShort(CutLen) == 0x05D3 or ReadShort(CutLen) == 0x02C0 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0506 and ReadByte(Save+0x1D59) == 0x05 then --Pre-Hades Escape Cutscene
        WriteByte(Save+0x930, 0x00)
        WriteByte(Save+0x938, 0x00)
        BitOr(Save+0x1D59, 0x02)
    end
    if ReadInt(Now+0x00) == 0x00330A06 and ReadByte(Save+0x1D59) == 0x17 then --Post Hades Escape Cutscene
        WriteByte(Save+0x94C, 0x01)
        BitOr(Save+0x1D59, 0x08)
    end
    if ReadShort(Now+0x00) == 0x0706 and ReadShort(CutLen) == 0x0745 then --Pre-Cerberus Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0706 and ReadByte(Save+0x1D59) == 0x1F and ReadByte(Save+0x354D) < 0x03 then --Post Cerberus Cutscene
        WriteByte(Now+0x01, 0x03)
        BitOr(Save+0x1D52, 0x02)
        BitOr(Save+0x1D59, 0x40)
        WriteByte(Save+0x1D6F, 0x03)
        WriteShort(Save+0x1F04, 0x0000)
        WriteShort(Save+0x1F1C, 0x0000)
    end
    if ReadInt(Now+0x00) == 0x00320106 and ReadByte(Save+0x1D52) == 0x02 then --Before Hercules Reunion Cutscene
        WriteByte(Save+0x926, 0x01)
        BitOr(Save+0x1D52, 0x18)
    end
    if ReadShort(Now+0x00) == 0x0106 and ReadShort(CutLen) == 0x0334 then --Hercules Reunion Cutscene
		WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x916, 0x00)
        BitOr(Save+0x1D52, 0x40)
	end
    if ReadShort(Now+0x00) == 0x1106 and ReadShort(CutLen) == 0x08E8 then --Post Demyx's Water Clones Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0806 and ReadByte(Save+0x1D54) == 0x11 then --Pre-Pete Cutscene
        WriteByte(Save+0x938, 0x00)
        WriteByte(Save+0x958, 0x02)
        WriteByte(Save+0x95C, 0x00)
        BitOr(Save+0x1D54, 0x02)
        BitOr(Save+0x1D5B, 0xC0)
        WriteByte(Save+0x1D6F, 0x07)
	end
    if ReadInt(Now+0x00) == 0x00350306 and ReadByte(Save+0x1D5C) == 0x04 then --Post Pete Cutscene
        BitOr(Save+0x1D5C, 0x02)
    end
    if ReadShort(Now+0x00) == 0x1206 and ReadShort(CutLen) == 0x10E9 then --Post Hydra Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0306 then --Underworld Entrance Cutscenes
        if ReadByte(Now+0x08) == 0x0A then --Before OC2, Cups Intro Cutscene
            WriteByte(Now+0x02, 0x36)
            WriteByte(Now+0x08, 0x16)
            WriteByte(Save+0x0E, 0x36)
            BitOr(Save+0x1D5C, 0x20)
        end
        if ReadByte(Now+0x08) == 0x0B then --Olympus Coliseum 2 1st Cutscene 1
            WriteInt(Now+0x02, 0x00050038)
            WriteByte(Now+0x08, 0x0D)
            WriteByte(Save+0x0E, 0x38)
            WriteByte(Save+0x922, 0x05)
            WriteByte(Save+0x926, 0x0D)
            WriteByte(Save+0x930, 0x0A)
            WriteByte(Save+0x93C, 0x0A)
            WriteByte(Save+0x942, 0x0A) --Unused Well of Capitivity BTL Flag for 2nd Visit?
            WriteByte(Save+0x954, 0x0A)
            WriteByte(Save+0x95A, 0x0A)
            WriteByte(Save+0x96C, 0x0A)
            WriteByte(Save+0x972, 0x0A)
            WriteByte(Save+0x978, 0x0A)
            BitOr(Save+0x1D54, 0x20)
            BitOr(Save+0x1D5C, 0x40)
        end
        if ReadByte(Now+0x08) == 0x0C then --Olympus Coliseum 2 1st Cutscene 2
            WriteInt(Now+0x02, 0x00050038)
            WriteByte(Now+0x08, 0x0D)
            WriteByte(Save+0x0E, 0x38)
            WriteByte(Save+0x922, 0x05)
            WriteByte(Save+0x926, 0x0D)
            WriteByte(Save+0x930, 0x0A)
            WriteByte(Save+0x93C, 0x0A)
            WriteByte(Save+0x954, 0x0A)
            WriteByte(Save+0x95A, 0x0A)
            WriteByte(Save+0x96C, 0x0A)
            WriteByte(Save+0x972, 0x0A)
            WriteByte(Save+0x978, 0x0A)
            BitOr(Save+0x1D54, 0x20)
            BitOr(Save+0x1D5C, 0x80)
        end
        if ReadByte(Now+0x02) == 0x33 and ReadByte(Save+0x1D5F) == 0x21 then --Post "Bad Alert" Cutscene
            BitOr(Save+0x1D5F, 0x02)
        end
	end
    if ReadShort(Now+0x00) == 0x0306 and ReadByte(Now+0x08) == 0x13 and ReadByte(Save+0x354D) == 0x03 then --Pre-Hades Cutscene
        WriteByte(Now+0x01, 0x0D)
    end
    if ReadShort(Now+0x00) == 0x1306 then --Hades Intermission Cutscene
        if ReadByte(Now+0x08) == 0xCA and ReadByte(Save+0x1D5A) == 0x94 then
            BitOr(Save+0x1D5A, 0x08)
        end
    end
    if ReadShort(Now+0x00) == 0x0D06 then --The Underdrome Cutscenes
        if ReadByte(Now+0x08) == 0xC8 then --Post Hades Cutscene
            WriteByte(CutSkp, 0x01)
            WriteByte(Save+0x962, 0x00)
            BitOr(Save+0x1D56, 0x20)
            WriteShort(Save+0x1D6E, 0x0C01)
        end
        if ReadShort(CutLen) == 0x0145 or ReadShort(CutLen) == 0x01E9 or ReadShort(CutLen) == 0x01E8 or ReadShort(CutLen) == 0x028B then --Post Cups Cutscene
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x2204 then --Zexion Cutscenes
        if ReadShort(CutLen) == 0x0140 or ReadShort(CutLen) == 0x00DC then --Post Zexion Cutscenes
            if ReadShort(CutNow) >= 0x0002 then
                WriteByte(CutSkp, 0x01)
            end
        end
	end
    if ReadShort(Now+0x00) == 0x100A and ReadByte(Now+0x08) == 0x01 then --Pride Lands 1 1st Cutscene
        WriteInt(Now+0x01, 0x01003206)
        WriteByte(Now+0x08, 0x13)
        WriteShort(Save+0x0D, 0x3206)
        WriteShort(Save+0x355D, 0x0201)
        WriteInt(Save+0xF32, 0x00010001)
        WriteByte(Save+0xF38, 0x13)
        WriteByte(Save+0xF74, 0x00)
        BitOr(Save+0x1DD0, 0x0E)
        BitOr(Save+0x1DD5, 0x10)
        WriteByte(Save+0x1DDF, 0x01)
    end
    if ReadShort(Now+0x00) == 0x040A and ReadByte(Save+0x1DD0) == 0x7F then --Leaving Pride Rock Cutscene
        WriteByte(Save+0xF10, 0x00)
        WriteByte(Save+0xF14, 0x00)
        BitOr(Save+0x1DD0, 0x80)
        WriteByte(Save+0x1DDF, 0x03)
    end
    if ReadShort(Now+0x00) == 0x030A and ReadByte(Save+0x1DD1) == 0x05 then --Oasis 1st Cutscene
        WriteByte(Save+0xF2C, 0x00)
        WriteByte(Save+0xF4A, 0x00)
        BitOr(Save+0x1DD1, 0x02)
    end
    if ReadShort(Now+0x00) == 0x070A and ReadByte(Save+0x1DD1) == 0x17 then --Pride Rock Rafiki Cutscene
        WriteInt(Save+0xF14, 0x00000000)
        BitOr(Save+0x1DD1, 0x08)
    end
    if ReadInt(Now+0x00) == 0x0033090A and ReadByte(Now+0x04) == 0x01 then --Simba & Nala Reunion Cutscene
        WriteByte(Now+0x04, 0x00)
        WriteInt(Save+0xF44, 0x00000000)
        BitOr(Save+0x1DD1, 0x40)
    end
    if ReadShort(Now+0x00) == 0x090A and ReadShort(CutLen) == 0x015A then --Circle of Life Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Now+0x01, 0x0C)
        BitOr(Save+0x1DD2, 0x01)
        WriteByte(Save+0x1DDF, 0x05)
    end
    if ReadShort(Now+0x00) == 0x040A and ReadByte(Save+0x1DDF) == 0x05 and ReadByte(Save+0x355D) < 0x83 then --Pre-Hyenas I Cutscene
        WriteByte(Now+0x01, 0x00)
        WriteByte(Save+0xF1A, 0x16)
        WriteByte(Save+0xF2C, 0x00)
        WriteByte(Save+0xF4A, 0x13)
        BitOr(Save+0x1DD2, 0x04)
        WriteByte(Save+0x1DDF, 0x06)
        WriteShort(Save+0x2048, 0x0000)
        WriteShort(Save+0x20B4, 0x0000)
        WriteShort(Save+0x20BA, 0x8574)
    end
    if ReadShort(Now+0x00) == 0x020A and ReadByte(Now+0x08) == 0x14 and ReadByte(Save+0x355D) == 0x83 then --Pre-Scar Cutscene
        WriteByte(Now+0x01, 0x0D)
	end
    if ReadShort(Now+0x00) == 0x0E0A and ReadShort(CutLen) == 0x0266 then --Post Scar Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1DD2, 0x40)
        WriteByte(Save+0x1DDF, 0x07)
	end
    if ReadShort(Now+0x00) == 0x040A and ReadByte(Now+0x08) == 0x0A then --Pride Lands 2 1st Cutscene
        WriteInt(Now+0x01, 0x02003300)
        WriteByte(Now+0x08, 0x0B)
        WriteShort(Save+0x0D, 0x3300)
        WriteByte(Save+0xF10, 0x02)
        WriteByte(Save+0xF14, 0x0B)
        WriteByte(Save+0xF1A, 0x14)
        WriteByte(Save+0xF24, 0x0A)
        WriteInt(Save+0xF2A, 0x0000000A)
        WriteByte(Save+0xF30, 0x0A)
        WriteByte(Save+0xF3C, 0x0A)
        WriteByte(Save+0xF42, 0x0A)
        BitOr(Save+0x1DD3, 0x06)
        BitOr(Save+0x1DD5, 0x80)
        WriteByte(Save+0x1DDF, 0x09)
        WriteInt(Save+0x20B0, 0xC3FAC3F9)
    end
    if ReadShort(Now+0x00) == 0x050A and ReadShort(CutLen) == 0x034A then --Pre-Hyenas II Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x050A and ReadByte(Save+0x1DD5) == 0xFC and ReadByte(Save+0x355D) < 0x83 then --Post Hyenas II Cutscene
        WriteByte(Now+0x01, 0x00)
        WriteByte(Save+0xF38, 0x15)
        BitOr(Save+0x1DD5, 0x01)
    end
    if ReadShort(Now+0x00) == 0x080A and ReadByte(Save+0x1DD4) == 0x8B and ReadByte(Save+0x355D) == 0x03 then --Simba Defeats Scar's Ghost Cutscene
        WriteByte(Now+0x01, 0x09)
        WriteByte(Save+0xF1A, 0x10)
        WriteByte(Save+0xF4A, 0x13)
        BitOr(Save+0x1DD4, 0x04)
    end
    if ReadShort(Now+0x00) == 0x000A and ReadShort(Save+0x355E) == 0x1212 then --Pre-Groundshaker Cutscene
        WriteByte(Now+0x01, 0x0F)
    end
    if ReadShort(Now+0x00) == 0x1A04 and ReadByte(Save+0x1DD6) == 0x03 then --Post Groundshaker Cutscene
        WriteByte(Save+0xF5E, 0x0D)
        BitOr(Save+0x1DD6, 0x04)
        WriteByte(Save+0x1DDE, 0x03)
    end
    if ReadShort(Now+0x00) == 0x0F12 and ReadShort(CutLen) == 0x00DC then --Post Data Saix Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0902 and ReadByte(Save+0x1CE2) == 0x58 and ReadShort(Save+0x353D) == 0x0201 then --Twilight Town 1 1st Cutscene
        WriteByte(Now+0x01, 0x17)
        BitOr(Save+0x1CE2, 0x20)
    end
    if ReadInt(Now+0x00) == 0x00320202 and ReadByte(Save+0x1CE3) == 0x02 then --Meeting Hayner/Pence/Olette Cutscene
        WriteByte(Save+0x326, 0x12)
        WriteByte(Save+0x364, 0x00)
        WriteByte(Save+0x368, 0x00)
        BitOr(Save+0x1CE3, 0x01)
        BitOr(Save+0x1CED, 0x08)
        WriteByte(Save+0x1D0D, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0402 then --Sandlot Cutscenes
        if ReadShort(CutLen) == 0x019F or ReadShort(CutLen) == 0x1216 then --Sandlot Nobodies
            WriteByte(CutSkp, 0x01)
        end
        if ReadByte(Now+0x08) == 0x4C and ReadByte(Save+0x1CD3) == 0x7F then --Post 3rd Tutorial Cutscene
            BitOr(Save+0x1CD3, 0x80)
        end
	end
    if ReadShort(Now+0x00) == 0x0802 and ReadShort(CutLen) == 0x040E then --Pre-Station Plaza Nobodies Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0902 and ReadShort(CutLen) == 0x035C then --Post Station Plaza Nobodies Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
            WriteByte(Save+0x326, 0x00)
            BitOr(Save+0x1CE3, 0x10)
            WriteByte(Save+0x1D0D, 0x02)
        end
	end
    if ReadShort(Now+0x00) == 0x1902 then --The Tower Cutscenes
        if ReadByte(Now+0x02) == 0x32 and ReadByte(Save+0x1CE3) == 0x3F then --Before Mysterious Tower Cutscene
            WriteByte(Save+0x346, 0x00)
            WriteByte(Save+0x34A, 0x12)
            BitOr(Save+0x1CE3, 0xC0)
            BitOr(Save+0x1CE4, 0x01)
            WriteShort(Save+0x207C, 0x0000)
            WriteShort(Save+0x20E4, 0x0000)
            WriteShort(Save+0x20F4, 0x0000)
            WriteShort(Save+0x2120, 0x0000)
        end
    end
    if ReadShort(Now+0x00) == 0x1C02 and ReadShort(CutLen) == 0x10FF then --Meeting Three Good Fairies Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x1B02 and ReadByte(Now+0x08) == 0x04 then --End of Twilight Town 1 Cutscene
        WriteByte(Save+0x364, 0x04)
        WriteByte(Save+0x3B8, 0x01)
        BitOr(Save+0x1CE5, 0x08)
        WriteByte(Save+0x1D0D, 0x06)
        WriteByte(Save+0x310, 0x00)
        WriteByte(Save+0x31C, 0x00)
        WriteByte(Save+0x322, 0x00)
        WriteByte(Save+0x328, 0x07)
        WriteByte(Save+0x334, 0x07)
        WriteByte(Save+0x340, 0x00)
        WriteByte(Save+0x352, 0x00)
        WriteByte(Save+0x38E, 0x00)
        WriteByte(Save+0x3A6, 0x00)
        WriteByte(Save+0x3AC, 0x00)
        WriteByte(Save+0x3B2, 0x00)
        WriteByte(Save+0x3B6, 0x00)
        WriteByte(Save+0x3BC, 0x00)
        WriteByte(Save+0x3E8, 0x00)
        WriteByte(Save+0x3EE, 0x00)
	end
    if ReadInt(Now+0x00) == 0x00360702 and ReadByte(Save+0x1D0D) == 0x07 then --Twilight Town 2 1st Cutscene
        WriteInt(Now+0x04, 0x00160000)
        WriteByte(Save+0x326, 0x10)
        WriteByte(Save+0x32C, 0x01)
        WriteByte(Save+0x334, 0x00)
        WriteArray(Save+0x338, {0x10, 0x00, 0x00, 0x00, 0x16})
        WriteByte(Save+0x33C, 0x16)
        WriteByte(Save+0x344, 0x10)
        WriteByte(Save+0x34A, 0x10)
        WriteByte(Save+0x350, 0x10)
        WriteByte(Save+0x356, 0x10)
        WriteByte(Save+0x35C, 0x10)
        WriteByte(Save+0x362, 0x00)
        BitOr(Save+0x1CE5, 0x40)
        BitOr(Save+0x1CE9, 0x20)
        BitOr(Save+0x1CED, 0x10)
        WriteByte(Save+0x1D0D, 0x08)
    end
    if ReadShort(Now+0x00) == 0x0802 and ReadShort(CutLen) == 0x0221 then --End of Twilight Town 2 Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x320, 0x12)
        WriteByte(Save+0x328, 0x00)
        WriteByte(Save+0x32C, 0x03)
        WriteByte(Save+0x344, 0x00)
        WriteByte(Save+0x362, 0x12)
        BitOr(Save+0x1CE6, 0xC0)
        WriteByte(Save+0x1D0D, 0x0A)
    end
    if ReadShort(Now+0x00) == 0x0E02 and ReadShort(CutLen) == 0x100B then --Pre-The Old Mansion Nobodies Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x1502 and ReadShort(CutLen) == 0x010E then --Entering Roxas's Twilight Town Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x38E, 0x04)
        BitOr(Save+0x1CE8, 0x04)
	end
    if ReadShort(Now+0x00) == 0x2802 and ReadShort(CutLen) == 0x0368 then --Pre-Betwixt and Between Nobodies Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x2802 and ReadShort(CutLen) == 0x0E9F then --Post Betwixt and Between Nobodies with Axel Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1CE9, 0x02)
        WriteByte(Save+0x1CFD, 0x01)
    end
    if ReadShort(Now+0x00) == 0x1402 and ReadShort(CutLen) == 0x00DC then --Post Data Axel Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x1402 and ReadShort(Now+0x30) == 0x1A04 and ReadByte(Now+0x08) == 0xD3 then --Data Axel (1 Hour)
        WriteArray(Now+0x04, {0xD5, 0x00, 0xD5, 0x00, 0xD5})
    end
    if ReadShort(Now+0x00) == 0x0004 and ReadByte(Now+0x08) == 0x01 then --Hollow Bastion 1 1st Cutscene
        WriteInt(Now+0x01, 0x0100320A)
        WriteByte(Now+0x08, 0x16)
        WriteByte(Save+0x0D, 0x320A)
        WriteByte(Save+0x614, 0x00)
        WriteByte(Save+0x64A, 0x01)
        WriteByte(Save+0x650, 0x16)
        BitOr(Save+0x1D10, 0x06)
        BitOr(Save+0x1D15, 0x60)
        BitOr(Save+0x1D1B, 0x20)
        BitOr(Save+0x1D1E, 0x06)
    end
    if ReadShort(Now+0x00) == 0x0904 and ReadShort(CutLen) == 0x03C3 or ReadShort(CutLen) == 0x05D0 then --Borough Cutscenes
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0D04 and ReadShort(CutLen) == 0x1732 then --Membership Card Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0804 and ReadShort(CutLen) == 0x0214 then --Pre-Bailey Nobodies Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D10, 0x80)
        BitOr(Save+0x1D1F, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0804 and ReadShort(CutLen) == 0x1DDA then --Post Bailey Nobodies Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1D2F, 0x02)
    end
    if ReadShort(Now+0x00) == 0x0A04 and ReadByte(Now+0x08) == 0x02 then --Hollow Bastion 2 1st Cutscene
        WriteByte(Now+0x02, 0x32)
        WriteByte(Now+0x08, 0x10)
        WriteByte(Save+0x0E, 0x32)
        WriteByte(Save+0x648, 0x02)
        WriteByte(Save+0x650, 0x10)
        WriteByte(Save+0x662, 0x02)
        BitOr(Save+0x1D10, 0x04)
        BitOr(Save+0x1D1E, 0x20)
	end
    if ReadInt(Now+0x00) == 0x00330504 and ReadByte(Save+0x1D2F) == 0x05 then --Talking to Leon Cutscene
        BitOr(Save+0x1D12, 0x1C)
        BitOr(Save+0x1D18, 0x20)
        WriteByte(Save+0x1D2F, 0x06)
        WriteArray(Save+0x203C, {0xB7, 0xC5, 0xB8, 0xC5, 0xBB, 0xC5, 0xBC, 0xC5})
        WriteInt(Save+0x20D4, 0x9D499D48)
        WriteInt(Save+0x2124, 0xC5BAC5B9)
	end
    if ReadShort(Now+0x00) == 0x0504 and ReadShort(CutLen) == 0x155F then --"Door to Darkness" Cutscene
		WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1D12, 0x40)
        BitOr(Save+0x1D13, 0x01)
	end
    if ReadInt(Now+0x00) == 0x00370504 and ReadByte(Save+0x1D13) == 0x03 then --"He wasn't really Ansem!" Cutscene
        if ReadByte(Save+0x365F) > 0 then --Unknown Disk
            WriteByte(Now+0x04, 0x11)
        end
        BitOr(Save+0x1D13, 0x04)
        BitOr(Save+0x1D20, 0x02)
	end
    if ReadShort(Now+0x00) == 0x1404 and ReadByte(Save+0x1D18) == 0x28 then --Corridors Fight
        WriteByte(Save+0x62E, 0x0D)
        WriteInt(Save+0x632, 0x00030000)
        BitOr(Save+0x1D18, 0x40)
    end
    if ReadInt(Now+0x00) == 0x00340604 and ReadByte(Save+0x1D2F) == 0x06 then --Post Corridors Fight
        BitOr(Save+0x1D20, 0x40)
        WriteByte(Save+0x1D2F, 0x07)
    end
    if ReadInt(Now+0x00) == 0x00321304 and ReadByte(Save+0x1D1F) == 0x03 then --Post Restoration Site Nobodies Cutscene
        WriteByte(Now+0x06, 0x03)
        WriteByte(Save+0x684, 0x03)
        BitOr(Save+0x1D1F, 0x04)
    end
    if ReadShort(Now+0x00) == 0x0404 and ReadByte(Save+0x1D2F) == 0x07 then --Pre-Demyx Cutscene
        WriteByte(Save+0x686, 0x00)
        BitOr(Save+0x1D14, 0x04)
        WriteByte(Save+0x1D2F, 0x08)
	end
    if ReadShort(Now+0x00) == 0x0304 and ReadShort(CutLen) == 0x07F4 then --Post Ravine Trail Heartless Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x1104 and ReadByte(Save+0x626) == 0x16 then --Pre-1,000 Heartless Cutscene
		WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x622, 0x00)
        WriteByte(Save+0x626, 0x00)
        BitOr(Save+0x1D14, 0x80)
        BitOr(Save+0x1D15, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0104 and ReadShort(CutLen) == 0x35EA then --Post 1,000 Heartless Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x616, 0x01)
        WriteByte(Save+0x61A, 0x16)
        WriteInt(Save+0x61E, 0x00030002)
        WriteByte(Save+0x62A, 0x01)
        WriteByte(Save+0x62E, 0x0E)
        WriteByte(Save+0x638, 0x12)
        WriteByte(Save+0x63C, 0x00)
        WriteByte(Save+0x642, 0x00)
        WriteByte(Save+0x648, 0x0B)
        WriteArray(Save+0x650, {0x06, 0x00, 0x01, 0x00, 0x0B})
        WriteByte(Save+0x65C, 0x16)
        WriteByte(Save+0x662, 0x10)
        WriteByte(Save+0x668, 0x10)
        WriteByte(Save+0x66C, 0x0B)
        WriteByte(Save+0x672, 0x0B)
        WriteInt(Save+0x67C, 0x000B000D)
        WriteInt(Save+0x684, 0x0000000B)
        BitOr(Save+0x1D15, 0x18)
        BitOr(Save+0x1D19, 0x70)
        BitOr(Save+0x1D1A, 0x7C)
        BitOr(Save+0x1D1C, 0x7C)
        BitOr(Save+0x1D1D, 0x7B)
        BitOr(Save+0x1D1E, 0x40)
        BitOr(Save+0x1D20, 0x20)
        BitOr(Save+0x1D21, 0x0C)
        BitOr(Save+0x1D22, 0x60)
        BitOr(Save+0x1D23, 0x01)
        BitOr(Save+0x1D24, 0x02)
        WriteShort(Save+0x1D2E, 0x0D02)
        WriteInt(Save+0x2032, 0x0000C687)
        WriteShort(Save+0x2038, 0x0000)
        WriteArray(Save+0x203C, {0x00, 0x00, 0x89, 0xC6, 0x00, 0x00, 0x8D, 0xC6})
        WriteShort(Save+0x20D4, 0x0000)
        WriteShort(Save+0x20D8, 0x0000)
        WriteShort(Save+0x210A, 0xA8CD)
        WriteShort(Save+0x2126, 0xC68B)
    end
    if ReadInt(Now+0x00) == 0x00320104 and ReadByte(Save+0x1D1F) == 0x1F then --Post Sephiroth Cutscene
        BitOr(Save+0x1D1F, 0x60)
    end
    if ReadShort(Now+0x00) == 0x0104 and ReadShort(CutLen) == 0x1649 then --Cloud vs Sephiroth Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0404 and ReadShort(CutLen) == 0x00DC then --Post Data Demyx Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x0010 and ReadByte(Now+0x08) == 0x01 then --Port Royal 1 1st Cutscene
        WriteByte(Now+0x02, 0x32)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x32)
        WriteShort(Save+0x3575, 0x0201)
        WriteByte(Save+0x1814, 0x00)
        WriteByte(Save+0x181A, 0x01)
        BitOr(Save+0x1E90, 0x10)
        BitOr(Save+0x1E99, 0x10)
        WriteInt(Save+0x20A0, 0x85468545)
    end
    if ReadShort(Now+0x00) == 0x0110 and ReadShort(CutLen) == 0x0A81 or ReadShort(CutLen) == 0x0242 then --Pre-Harbor Pirates 1/2 Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0210 and ReadShort(CutLen) == 0x02B2 then --Pre-Town Heartless Cutscene
        WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x00330310 and ReadByte(Save+0x1E9F) == 0x00 then --Elizabeth & Barbossa Cutscene
        WriteByte(Save+0x1E9F, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0310 and ReadByte(Save+0x1E9F) == 0x01 and ReadByte(Save+0x3577) == 0x12 then --After 1st Ambush Cutscene
        WriteByte(Now+0x01, 0x19)
        WriteByte(Save+0x1826, 0x00)
        WriteByte(Save+0x184C, 0x01)
        BitOr(Save+0x1E92, 0x01)
        BitOr(Save+0x1E9C, 0x02)
		WriteByte(Save+0x1E9F, 0x02)
        WriteInt(Save+0x2098, 0x854A8549)
        BitOr(Save+0x2397, 0x06)
	end
    if ReadShort(Now+0x00) == 0x0910 and ReadShort(CutLen) == 0x0104 then --Post 1 Minute Fight Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1E92, 0x08)
        BitNot(Save+0x1E92, 0x01)
        WriteByte(Save+0x1E9F, 0x03)
        WriteShort(Save+0x209A, 0xC1BC)
        WriteShort(Save+0x20A4, 0x0000)
	end
    if ReadShort(Now+0x00) == 0x0410 and ReadShort(CutLen) == 0x082F then --Pre-Medallion Fight Cutscene
        WriteByte(CutSkp, 0x01)    
        WriteByte(Save+0x182C, 0x00)
        WriteByte(Save+0x1832, 0x00)
        BitOr(Save+0x1E92, 0x40)
	end
    if ReadShort(Now+0x00) == 0x0710 and ReadByte(Save+0x1E93) == 0x02 and ReadByte(Save+0x3575) == 0x83 then --Post Medallion Fight Cutscene
        WriteByte(Now+0x01, 0x04)
        BitOr(Save+0x1E93, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0410 and ReadShort(CutLen) == 0x033F then --Post Medallion Fight Cutscene 2
		WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x00320810 and ReadByte(Save+0x1E93) == 0x0B then --Post Barrels Cutscene
        BitOr(Save+0x1E93, 0x04)
        WriteShort(Save+0x205C, 0x0000)
    end
    if ReadShort(Now+0x00) == 0x0A10 and ReadShort(CutLen+0x00) == 0x0F1E then --Pre-Captain Barbossa Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0A10 and ReadShort(CutLen) == 0x0845 then --Post Captain Barbossa Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1E93, 0x20)
        WriteByte(Save+0x1E9F, 0x05)
        WriteByte(Save+0x3575, 0x03)
    end
    if ReadShort(Now+0x00) == 0x0A10 and ReadByte(Now+0x08) == 0x0A then --Port Royal 2 1st Cutscene
        WriteInt(Now+0x01, 0x02003300)
        WriteByte(Now+0x08, 0x14)
        WriteShort(Save+0x0D, 0x3300)
        WriteByte(Save+0x1814, 0x14)
        WriteByte(Save+0x181A, 0x0A)
        WriteByte(Save+0x184C, 0x02)
        WriteByte(Save+0x1850, 0x00)
        BitOr(Save+0x1E93, 0x80)
        BitOr(Save+0x1E94, 0x01)
        BitOr(Save+0x1E99, 0x80)
        WriteByte(Save+0x1E9F, 0x07)
        WriteInt(Save+0x20A0, 0x85528551)
	end
    if ReadInt(Now+0x00) == 0x00320610 and ReadByte(Save+0x1E94) == 0x27 then --Before Grim Reaper I Cutscene
        BitOr(Save+0x1E94, 0x10)
	end
    if ReadInt(Now+0x00) == 0x00320B10 and ReadByte(Save+0x1E9F) == 0x08 then --Post Grim Reaper I Cutscene
        BitOr(Save+0x1E9C, 0x04)
        WriteByte(Save+0x1E9F, 0x09)
    end
    if ReadShort(Now+0x00) == 0x0E10 and ReadByte(Save+0x1E9F) == 0x09 then --Pre-Gambler Cutscene
		WriteByte(Save+0x1E9F, 0x0A)
	end
    if ReadShort(Now+0x00) == 0x0E10 and ReadShort(CutLen+0x00) == 0x01D6 then --Pre-Gambler Cutscene (Boss/Enemy)
		WriteByte(CutSkp+0x00, 0x01)
	end
    if ReadShort(Now+0x00) == 0x0E10 and ReadShort(CutLen) == 0x045C then --Post Gambler Cutscene
		WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1856, 0x00)
        BitOr(Save+0x1E95, 0x04)
	end
    if ReadShort(Now+0x00) == 0x0510 and ReadByte(Now+0x08) == 0x14 and ReadByte(Save+0x1E97) == 0x00 then --Post Medallion Collection Cutscene
        WriteByte(Save+0x1848, 0x15)
        WriteByte(Save+0x184E, 0x15)
        WriteByte(Save+0x1854, 0x15)
        WriteByte(Save+0x185A, 0x15)
        WriteByte(Save+0x1860, 0x15)
        WriteByte(Save+0x1866, 0x15)
        WriteByte(Save+0x186C, 0x15)
        BitOr(Save+0x1E97, 0x20)
	end
    if ReadShort(Now+0x00) == 0x0510 and ReadByte(Now+0x08) == 0x0D then --Post Medallion Collection Cutscene (Boss/Enemy)
        WriteArray(Now+0x02, {0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x14})
        WriteByte(Save+0x0E, 0x33)
        WriteByte(Save+0x1816, 0x05)
        WriteByte(Save+0x181A, 0x0B)
        WriteByte(Save+0x1832, 0x14)
        WriteByte(Save+0x1838, 0x13)
        WriteByte(Save+0x1848, 0x15)
        WriteByte(Save+0x184E, 0x15)
        WriteByte(Save+0x1854, 0x15)
        WriteByte(Save+0x185A, 0x15)
        WriteByte(Save+0x1860, 0x15)
        WriteByte(Save+0x1866, 0x15)
        WriteByte(Save+0x186C, 0x15)
        BitOr(Save+0x1E95, 0x20)
        BitOr(Save+0x1E97, 0x20)
        BitNot(Save+0x2398, 0x40)
        BitOr(Save+0x239E, 0x10)
    end
    if ReadShort(Now+0x00) == 0x0110 and ReadShort(CutLen) == 0x0807 then --Post Grim Reaper II Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1E95, 0x80)
        WriteByte(Save+0x1E9E, 0x02)
	end
    if ReadShort(Now+0x00) == 0x0E12 and ReadShort(CutLen) == 0x00DC then --Post Data Luxord Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x010C and ReadByte(Now+0x08) == 0x35 then --Disney Castle 1st Cutscene
        WriteArray(Now+0x00, {0x0C, 0x06, 0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16})
        WriteInt(Save+0x0C, 0x0032060C)
        WriteShort(Save+0x3565, 0x0201)
        WriteByte(Save+0x1226, 0x01)
        WriteByte(Save+0x1238, 0x16)
        BitOr(Save+0x1E10, 0x04)
        BitOr(Save+0x1E12, 0x01)
        WriteByte(Save+0x1E1F, 0x01)
    end
    if ReadShort(Now+0x00) == 0x010C and ReadShort(CutLen) == 0x0C6C then --Meeting Queen Minnie Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x000C and ReadByte(Save+0x1E13) == 0x20 then --Pre-Minnie Escort 2 Cutscene
        WriteInt(Save+0x121E, 0x00000004)
        BitOr(Save+0x1E13, 0x40)
    end
    if ReadShort(Now+0x00) == 0x000C and ReadByte(Save+0x1E1F) == 0x02 and ReadByte(Save+0x3565) ~= 0x12 then --Post Minnie Escort 2 Cutscene
        WriteByte(Now+0x01, 0x04)
        WriteInt(Save+0x1210, 0x00010001)
        WriteInt(Save+0x1216, 0x00000000)
        WriteInt(Save+0x121C, 0x00010000)
        WriteByte(Save+0x1228, 0x01)
        WriteByte(Save+0x1238, 0x14)
        BitOr(Save+0x1E11, 0x02)
        WriteByte(Save+0x1E1F, 0x03)
    end
    if ReadInt(Now+0x00) == 0x0032040C and ReadByte(Now+0x08) == 0x04 then --Before Start of TR in DC
        WriteInt(Now+0x02, 0x00020033)
        WriteByte(Now+0x08, 0x03)
        WriteInt(Save+0x0E, 0x33)
        WriteByte(Save+0x1228, 0x02)
        WriteByte(Save+0x122C, 0x03)
        WriteByte(Save+0x1238, 0x13)
        BitOr(Save+0x1D15, 0x80)
        BitOr(Save+0x1D16, 0x01)
        BitOr(Save+0x1E11, 0x10)
        BitOr(Save+0x1E12, 0x02)
        WriteByte(Save+0x1E1F, 0x03)
    end
    if ReadShort(Now+0x00) == 0x1A04 and ReadByte(Save+0x122C) == 0x04 and ReadByte(Save+0x365D) >= 0x02 then --Before Start of TR in GoA
        WriteByte(Save+0x1228, 0x02)
        WriteByte(Save+0x122C, 0x03)
        WriteInt(Save+0x1238, 0x00010013)
        BitOr(Save+0x1D15, 0x80)
        BitOr(Save+0x1D16, 0x01)
        BitOr(Save+0x1E11, 0x10)
        BitOr(Save+0x1E12, 0x02)
        WriteByte(Save+0x1E1F, 0x03)
    end
    if ReadInt(Now+0x00) == 0x0063040C and ReadByte(Save+0x123A) == 0x01 then --Correct Spawn from GoA
        WriteByte(Now+0x02, 0x33)
        WriteByte(Save+0x123A, 0x00)
    end
    if ReadInt(Now+0x00) == 0x0032000D and ReadByte(Save+0x1E30) == 0x02 then --Entering Timeless River Cutscene
        WriteByte(Now+0x04, 0x01)
        WriteByte(Save+0x1210, 0x03)
        WriteInt(Save+0x121A, 0x00040013)
        WriteByte(Save+0x1222, 0x01)
        WriteByte(Save+0x1228, 0x00)
        WriteByte(Save+0x122C, 0x00)
        WriteByte(Save+0x1390, 0x01)
        WriteByte(Save+0x1396, 0x01)
        BitOr(Save+0x1D1E, 0x09)
        BitOr(Save+0x1E11, 0x20)
        BitOr(Save+0x1E30, 0x01)
        BitOr(Save+0x1E34, 0x20)
    end
    if ReadInt(Now+0x00) == 0x0033000D and ReadByte(Save+0x1E30) == 0x17 then --Post Past Pete Cutscene
		WriteByte(Now+0x04, 0x00)
        WriteByte(Save+0x1390, 0x00)
        WriteByte(Save+0x139A, 0x16)
        BitOr(Save+0x1E30, 0x08)
	end
    if ReadShort(Now+0x00) == 0x050D and ReadShort(CutLen) == 0x0322 or ReadShort(CutLen) == 0x02D5 then -- Pre-Building Site Heartless Cutscenes
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x040D and ReadShort(CutLen) == 0x0507 or ReadShort(CutLen) == 0x048E then --Pre-Lilliput Heartless Cutscenes
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x060D and ReadShort(CutLen) == 0x0255 or ReadShort(CutLen) == 0x0219 then --Pre-Scene of the Fire Heartless Cutscenes
        WriteByte(CutSkp, 0x01)
	end
    if ReadShort(Now+0x00) == 0x070D and ReadShort(CutLen) == 0x023E then --Pre-Mickey's House Heartless Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x080D and ReadShort(CutLen) == 0x0807 then --Before Waterway Pete Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x030D and ReadShort(CutLen) == 0x094F then --Post Wharf Pete Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x1210, 0x04)
        WriteByte(Save+0x1390, 0x03)
        WriteInt(Save+0x1394, 0x00020013)
        WriteByte(Save+0x139C, 0x00)
        WriteByte(Save+0x13A2, 0x01)
        BitOr(Save+0x1E11, 0x40)
        WriteByte(Save+0x1E1E, 0x03)
        BitOr(Save+0x1E33, 0x0E)
        BitOr(Save+0x1E34, 0x80)
	end
    if ReadShort(Now+0x00) == 0x050C and ReadByte(Now+0x08) == 0x02 then --Lingering Will's Portal Cutscene
        WriteInt(Now+0x02, 0x00010000)
        WriteByte(Now+0x08, 0x15)
        WriteByte(Save+0x0E, 0x00)
        WriteByte(Save+0x122E, 0x01)
        WriteByte(Save+0x1232, 0x15)
        BitOr(Save+0x1E14, 0x02)
    end
    if ReadShort(Now+0x00) == 0x2604 then --Post Marluxia Cutscenes
        if ReadShort(CutLen) == 0x0125 or ReadShort(CutLen) == 0x00DC then
            if ReadShort(CutNow) >= 0x0002 then
                WriteByte(CutSkp, 0x01)
            end
        end
	end
    if ReadShort(Now+0x00) == 0x070C then --Post Lingering Will Cutscenes
        if ReadShort(CutLen) == 0x02EC or ReadShort(CutLen) == 0x016E then
            if ReadShort(CutNow) >= 0x0002 then
                WriteByte(CutSkp, 0x01)
            end
        end
    end
    if ReadShort(Now+0x00) == 0x0111 and ReadByte(Now+0x08) == 0x01 then --Space Paranoids 1 1st Cutscene
        WriteArray(Now+0x01, {0x00, 0x34, 0x00, 0x00, 0x00, 0x01, 0x00, 0x02})
        WriteShort(Save+0x0D, 0x3400)
        WriteShort(Save+0x3579, 0x0201)
        WriteInt(Save+0x1992, 0x00020001)
        WriteByte(Save+0x199A, 0x00)
        BitOr(Save+0x1EB0, 0x06)
        BitOr(Save+0x1EB5, 0x80)
        WriteByte(Save+0x1EBF, 0x01)
    end
    if ReadShort(Now+0x00) == 0x0411 and ReadByte(Now+0x08) == 0x37 and ReadShort(CutLen) == 0x0015 then --Post Hostile Program Cutscene
        WriteByte(Save+0x19AE, 0x00)
        BitOr(Save+0x1EB2, 0x02)
	end
    if ReadShort(Now+0x00) == 0x0511 and ReadShort(CutLen) == 0x05CC then --End of Space Paranoids 1 Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1EB4, 0x40)
        WriteByte(Save+0x1EBF, 0x03)
	end
    if ReadShort(Now+0x00) == 0x0111 and ReadByte(Now+0x08) == 0x0A then --Space Paranoids 2 1st Cutscene
        WriteInt(Now+0x01, 0x03003700)
        WriteByte(Now+0x08, 0x0B)
        WriteShort(Save+0x0D, 0x3700)
        WriteByte(Save+0x1994, 0x0B)
        WriteInt(Save+0x1998, 0x0000000A)
        WriteByte(Save+0x19A0, 0x0A)
        WriteByte(Save+0x19A4, 0x0A)
        WriteByte(Save+0x19AA, 0x0A)
        WriteByte(Save+0x19B6, 0x0A)
        BitOr(Save+0x1EB2, 0x60)
        BitOr(Save+0x1EB5, 0x01)
        BitOr(Save+0x1EB6, 0x04)
        WriteByte(Save+0x1EBF, 0x05)
        WriteInt(Save+0x210C, 0xC97DC97C)
        BitOr(Save+0x2398, 0x10)
    end
    if ReadShort(Now+0x00) == 0x0211 and ReadByte(Save+0x3579) == 0x03 then --Post Game Grid Heartless
        WriteByte(Now+0x01, 0x00)
        BitOr(Save+0x1EB3, 0x01)
    end
    if ReadInt(Now+0x00) == 0x00340511 and ReadByte(Save+0x1EBF) == 0x05 then --Post I/O Tower: Hallway Heartless Cutscene
        WriteByte(Save+0x1EBF, 0x06)
    end
    if ReadShort(Now+0x00) == 0x0711 and ReadByte(Save+0x1EB3) == 0x5F then --Pre-Solar Sailer Heartless Cutscene
        WriteByte(Save+0x19AE, 0x00)
        WriteByte(Save+0x19B2, 0x12)
        WriteByte(Save+0x19D0, 0x16)
        BitOr(Save+0x1EB3, 0x20)
	end
    if ReadShort(Now+0x00) == 0x0811 and ReadByte(Save+0x1EBF) == 0x06 then --Before Sark & MCP
        BitOr(Save+0x1EB3, 0x80)
        WriteByte(Save+0x1EBF, 0x07)
    end
    if ReadShort(Now+0x00) == 0x0102 and ReadByte(Now+0x08) == 0x34 then --Simulated Twilight Town 1st Cutscene
        WriteArray(Now+0x00, {0x02, 0x07, 0x00, 0x00, 0x5F, 0x00, 0x5F, 0x00, 0x5F})
        WriteInt(Save+0x0C, 0x00000702)
        BitOr(Save+0x1CD2, 0x40)
        BitOr(Save+0x1CD3, 0x07)
        BitOr(Save+0x1CF8, 0x03)
    end
    if ReadShort(Now+0x00) == 0x0702 then --Market Street: Tram Common Cutscenes
        if ReadByte(Now+0x08) == 0x5F and ReadShort(Save+0x20E8) == 0x0000 then --Pre-1st Tutorial Cutscene
            WriteArray(Save+0x20DC, {0x40, 0x9F, 0x53, 0x9F, 0x3E, 0x9F, 0x51, 0x9F})
            WriteArray(Save+0x20E6, {0x55, 0x9F, 0x41, 0x9F, 0x54, 0x9F, 0x3F, 0x9F, 0x52, 0x9F})
        end
        if ReadByte(Now+0x08) == 0x61 and ReadByte(Save+0x1CD3) == 0x17 then --Post 1st Tutorial Cutscene
            BitOr(Save+0x1CD3, 0x08)
        end
        if ReadByte(Now+0x08) == 0x63 and ReadByte(Save+0x1CD3) == 0x5F then --Post 2nd Tutorial Cutscene
            BitOr(Save+0x1CD3, 0x20)
        end
    end
    if ReadInt(Now+0x00) == 0x00320D02 and ReadByte(Save+0x1CD4) == 0x17 then --Post Seifer Cutscene
        WriteByte(Now+0x04, 0x01)
        WriteByte(Save+0x35E, 0x01)
        BitOr(Save+0x1CD4, 0x08)
        if ReadByte(Load) == 3 then
            WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
        elseif ReadByte(Load) ~= 3 and ReadByte(Cntrl) == 3 then
            WriteByte(Cntrl, 0)
        end
    end
    if ReadShort(Now+0x00) == 0x0E02 and ReadByte(Now+0x08) == 0x80 and ReadByte(Load) ~= 0 then --Old Mansion Dusk
        WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
    end
    if ReadInt(Now+0x00) == 0x00330202 and ReadByte(Save+0x1CD6) == 0x02 then --Post Old Mansion Dusk Cutscene
        BitOr(Save+0x1CD4, 0x80)
        BitOr(Save+0x1CD5, 0xFF)
        BitOr(Save+0x1CD6, 0x01)
        WriteByte(Save+0x1D0E, 0x01)
        WriteShort(Save+0x3FF5, 0x0102)
        if ReadByte(Load) ~= 0 then
            WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
        end
    end
    if ReadShort(Now+0x00) == 0x0202 and ReadShort(CutLen) == 0x0140 then --Post Save Point Tutorial Cutscene
		WriteByte(CutSkp, 0x01)
        WriteArray(Save+0x31E, {0x00, 0x00, 0x00, 0x00, 0x01})
        BitOr(Save+0x1CD6, 0x02)
        WriteShort(Save+0x20E0, 0x0000)
	end
    if ReadInt(Now+0x00) == 0x00320202 and ReadByte(Save+0x1D0E) == 0x02 then --Munny Pouch Cutscene (Day 2 End)
        WriteByte(Save+0x346, 0x01)
        BitOr(Save+0x1CD6, 0xE0)
        BitOr(Save+0x1CD7, 0xFF)
        BitOr(Save+0x1CD8, 0x01)
        WriteByte(Save+0x1D0E, 0x03)
        WriteArray(Save+0x207C, {0x4C, 0x9F, 0x5F, 0x9F, 0x00, 0x00})
        WriteByte(Save+0x20DE, 0x5E)
        WriteShort(Save+0x20E8, 0x0000)
        WriteByte(Save+0x3FF5, 0x03)
    end
    if ReadShort(Now+0x00) == 0x0402 and ReadByte(Save+0x1CD8) == 0x23 then --Pre-Sandlot Dusk Cutscene
        WriteByte(Save+0x326, 0x00)
        WriteByte(Save+0x32C, 0x00)
        WriteByte(Save+0x334, 0x05)
        WriteInt(Save+0x338, 0x00050000)
        WriteByte(Save+0x33E, 0x00)
        WriteByte(Save+0x362, 0x00)
        BitOr(Save+0x1CD8, 0x1C)
        WriteInt(Save+0x20EC, 0xC4A00000)
        WriteShort(Save+0x2114, 0x0000)
    end
    if ReadShort(Now+0x00) == 0x2002 and ReadByte(Save+0x1CD8) == 0x3F then --Post Sandlot Dusk Cutscene
        BitOr(Save+0x1CD8, 0xC0)
        WriteByte(Save+0x1D0E, 0x04)
        if ReadByte(Load) ~= 0 then
            WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
        end
    end
    if ReadShort(Now+0x00) == 0x2202 and ReadShort(CutLen) == 0x047B then --Pre-Twilight Thorn Cutscene
		WriteByte(CutSkp, 0x01)
	end
    if ReadInt(Now+0x00) == 0x00320502 and ReadByte(Save+0x1CD9) == 0x0F then --Post Twilight Thorn Cutscene
        WriteByte(Save+0x322, 0x02)
        WriteByte(Save+0x334, 0x02)
        WriteInt(Save+0x338, 0x00020014)
        WriteByte(Save+0x33E, 0x14)
        WriteByte(Save+0x344, 0x14)
        WriteByte(Save+0x34A, 0x14)
        WriteByte(Save+0x362, 0x14)
        WriteByte(Save+0x368, 0x14)
        BitOr(Save+0x1CD9, 0xF0)
        BitOr(Save+0x1CDA, 0x7F)
        WriteByte(Save+0x1D0E, 0x05)
        WriteInt(Save+0x20E8, 0xC543C542)
        WriteInt(Save+0x2114, 0xC541C540)
        WriteByte(Save+0x3FF5, 0x04)
	end
    if ReadShort(Now+0x00) == 0x0502 and ReadByte(Now+0x08) == 0x04 then --Post Hayner Cutscene
        if ReadByte(Load) == 3 then
            WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
        elseif ReadByte(Load) ~= 3 and ReadByte(Cntrl) == 3 then
            WriteByte(Cntrl, 0)
        end
    end
    if ReadShort(Now+0x00) == 0x0502 and ReadByte(Now+0x08) == 0x56 and ReadByte(Load) ~= 0 then --Post Vivi Cutscene
        WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
    end
    if ReadShort(Now+0x00) == 0x0502 and ReadShort(CutLen) == 0x0516 or ReadShort(CutLen) == 0x05E8 then --Post Setzer Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1CDC, 0xFC)
        BitOr(Save+0x1CDD, 0x01)
        WriteByte(Save+0x1D0E, 0x06)
        WriteShort(Save+0x20E8, 0x0000)
        WriteShort(Save+0x2114, 0x0000)
	end
    if ReadInt(Now+0x00) == 0x00320B02 and ReadByte(Save+0x1CDD) == 0xE7 then --Pre-Seven Wonders Cutscene
        WriteByte(Save+0x320, 0x00)
        WriteByte(Save+0x338, 0x13)
        WriteByte(Save+0x344, 0x13)
        WriteByte(Save+0x348, 0x14)
        BitOr(Save+0x1CDD, 0x18)
        BitOr(Save+0x1CDE, 0x07)
        BitOr(Save+0x1CED, 0x01)
        BitOr(Save+0x1CEF, 0x80)
        WriteByte(Save+0x1D0E, 0x07)
        WriteShort(Save+0x207C, 0x0000)
	end
    if ReadInt(Now+0x00) == 0x00340802 and ReadByte(Save+0x1CDE) == 0x27 then --Post Seven Wonders Cutscene
        WriteByte(Save+0x35C, 0x13)
        BitOr(Save+0x1CDE, 0x18)
        WriteByte(Save+0x1D0E, 0x09)
	end
    if ReadInt(Now+0x00) == 0x00320202 and ReadByte(Save+0x1D0E) == 0x09 then --End of Day 5 Cutscene
        WriteByte(Save+0x368, 0x00)
        BitOr(Save+0x1CDE, 0xC0)
        BitOr(Save+0x1CDF, 0xFF)
        WriteByte(Save+0x1D0E, 0x0A)
        WriteShort(Save+0x2080, 0x0000)
        WriteShort(Save+0x3FF5, 0x0006)
	end
    if ReadShort(Now+0x00) == 0x0302 and ReadByte(Now+0x08) == 0x49 and ReadByte(Load) ~= 0 then --Pre-Back Alley Nobodies Cutscene
        WriteByte(Cntrl, 3) --Prevent losing last equipped Keyblade
    end
    if ReadShort(Now+0x00) == 0x1202 and ReadShort(CutLen) == 0x03C7 then --Entering Namine's Room Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0x380, 0x00)
        BitOr(Save+0x1CE0, 0x20)
    end
    if ReadShort(Now+0x00) == 0x1502 and ReadByte(Save+0x1CE1) == 0x01 then --Entering Computer Room Cutscene
        WriteByte(Save+0x382, 0x03)
        WriteByte(Save+0x386, 0x01)
        WriteByte(Save+0x38E, 0x02)
        BitOr(Save+0x1CE1, 0x02)
    end
    if ReadShort(Now+0x00) == 0x1302 and ReadShort(CutLen) == 0x00DC then --Pre-Basement Hall Nobodies Cutscenes
        WriteByte(CutSkp, 0x01)
    end
    if ReadInt(Now+0x00) == 0x00321302 and ReadByte(Save+0x1CE1) == 0x0F then --Post Axel II Cutscene
        WriteByte(Now+0x04, 0x01)
        WriteByte(Now+0x08, 0x02)
        WriteByte(Save+0x346, 0x02)
        WriteByte(Save+0x34A, 0x13)
        WriteByte(Save+0x378, 0x00)
        WriteByte(Save+0x382, 0x01)
        WriteByte(Save+0x386, 0x02)
        BitOr(Save+0x1CE1, 0x30)
        WriteByte(Save+0x1D0E, 0x0D)
        WriteShort(Save+0x2114, 0x0000)
        WriteShort(Save+0x211C, 0x0000)
	end
    if ReadShort(Now+0x00) == 0x1702 and ReadByte(Now+0x08) == 0x01 then --End of STT Cutscene
        WriteByte(Save+0x39A, 0x0D)
        WriteByte(Save+0x39E, 0x00)
        BitOr(Save+0x1CE2, 0x01)
        WriteByte(Save+0x1CFE, 0x05)
	end
    if ReadShort(Now+0x00) == 0x1512 and ReadShort(CutLen) == 0x00DC then --Post Data Roxas Cutscene
        if ReadShort(CutNow) >= 0x0002 then
            WriteByte(CutSkp, 0x01)
        end
	end
    if ReadShort(Now+0x00) == 0x1512 and ReadByte(Now+0x08) == 0x71 and ReadShort(Now+0x30) == 0x1A04 then --Data Roxas (1 Hour)
        WriteArray(Now+0x04, {0x63, 0x00, 0x63, 0x00, 0x63})
    end
    if ReadShort(Now+0x00) == 0x0009 and ReadByte(Now+0x08) == 0x03 then --Before Piglet's House Cutscene
		WriteInt(Now+0x02, 0x00040033)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x33)
        WriteByte(Save+0xD90, 0x04)
        WriteByte(Save+0xD94, 0x00)
        WriteByte(Save+0xDA0, 0x15)
        WriteByte(Save+0xDAC, 0x01)
        BitOr(Save+0x1DB1, 0x02)
        BitOr(Save+0x1DB7, 0x10)
        WriteByte(Save+0x3598, ReadByte(Save+0x3598)-1)
	end
    if ReadShort(Now+0x00) == 0x0009 and ReadByte(Now+0x08) == 0x05 then --Before Rabbit's House Cutscene
		WriteInt(Now+0x02, 0x00070034)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x34)
        WriteByte(Save+0xD90, 0x07)
        WriteByte(Save+0xD94, 0x00)
        WriteByte(Save+0xDA0, 0x13)
        WriteByte(Save+0xDA6, 0x01)
        WriteByte(Save+0xDAC, 0x13)
        BitOr(Save+0x1DB2, 0x02)
        BitOr(Save+0x1DB7, 0x80)
        WriteByte(Save+0x3598, ReadByte(Save+0x3598)-1)
	end
    if ReadShort(Now+0x00) == 0x0009 and ReadByte(Now+0x08) == 0x07 then --Before Kanga's House Cutscene
		WriteInt(Now+0x02, 0x000A0035)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x35)
        WriteByte(Save+0xD90, 0x0A)
        WriteByte(Save+0xD94, 0x00)
        WriteByte(Save+0xDA0, 0x11)
        WriteByte(Save+0xDA6, 0x11)
        WriteByte(Save+0xDAC, 0x11)
        WriteByte(Save+0xDB2, 0x01)
        BitOr(Save+0x1DB3, 0x02)
        BitOr(Save+0x1DB8, 0x04)
        WriteByte(Save+0x3598, ReadByte(Save+0x3598)-1)
	end
    if ReadShort(Now+0x00) == 0x0009 and ReadByte(Now+0x08) == 0x09 then --Before The Spooky Cave Cutscene
		WriteInt(Now+0x02, 0x000D0036)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x36)
        WriteByte(Save+0xD90, 0x0D)
        WriteByte(Save+0xD94, 0x00)
        WriteByte(Save+0xDA0, 0x0F)
        WriteByte(Save+0xDA6, 0x0F)
        WriteByte(Save+0xDAC, 0x0F)
        WriteByte(Save+0xDB2, 0x0F)
        WriteByte(Save+0xDCA, 0x01)
        BitOr(Save+0x1DB4, 0x02)
        BitOr(Save+0x1DB8, 0x10)
        WriteByte(Save+0x3598, ReadByte(Save+0x3598)-1)
	end
    if ReadShort(Now+0x00) == 0x0909 and ReadShort(CutLen) == 0x0BD7 then --Post The Expotition Cutscene
        WriteByte(CutSkp, 0x01)
        WriteByte(Save+0xDA0, 0x0E)
        WriteByte(Save+0xDA6, 0x0E)
        WriteByte(Save+0xDAC, 0x0E)
        WriteByte(Save+0xDB2, 0x0E)
        WriteByte(Save+0xDCA, 0x0E)
        BitOr(Save+0x1DB4, 0x60)
        if ReadByte(Save+0x1DB4) == 0x67 then --Starry Hill not accessible
            WriteByte(Save+0xD90, 0x0E)
        end
	end
    if ReadShort(Now+0x00) == 0x0009 and ReadByte(Now+0x08) == 0x0B then --Before Starry Hill Cutscene
		WriteInt(Now+0x02, 0x00100037)
        WriteByte(Now+0x08, 0x00)
        WriteByte(Save+0x0E, 0x37)
        WriteByte(Save+0xD90, 0x10)
        WriteByte(Save+0xD94, 0x00)
        WriteByte(Save+0xD9A, 0x01)
        WriteByte(Save+0xDA0, 0x0D)
        WriteByte(Save+0xDA6, 0x0D)
        WriteByte(Save+0xDAC, 0x0D)
        WriteByte(Save+0xDB2, 0x0D)
        WriteByte(Save+0xDCA, 0x0D)
        BitOr(Save+0x1DB5, 0x01)
        BitOr(Save+0x1DB8, 0x80)
        WriteByte(Save+0x3598, ReadByte(Save+0x3598)-1)
	end
    if ReadShort(Now+0x00) == 0x0109 and ReadShort(CutLen) == 0x128A then --Post The Hunny Pot Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1DB5, 0x10)
    end
    if ReadShort(Now+0x00) == 0x070B and ReadByte(Now+0x08) == 0x01 then --Atlantica 1st Cutscene
        WriteArray(Now+0x01, {0x02, 0x00, 0x00, 0x34, 0x00, 0x34, 0x00, 0x34})
        WriteByte(Save+0x0D, 0x02)
        WriteByte(Save+0x109C, 0x01)
        WriteByte(Save+0x10BE, 0x00)
        BitOr(Save+0x1DF0, 0x06)
        BitOr(Save+0x1DF5, 0x80)
        WriteInt(Save+0x209C, 0x857E857D)
    end
    if ReadShort(Now+0x00) == 0x020B and ReadShort(CutLen) == 0x0106 then --Post Atlantica Tutorial Cutscene
        WriteByte(CutSkp, 0x01)
    end
    if ReadShort(Now+0x00) == 0x040B and ReadByte(Save+0x1DF0) == 0x0F then --Pre-Swim This Way Cutscene
        BitOr(Save+0x1DF0, 0x10)
    end
    if ReadShort(Now+0x00) == 0x1A04 and ReadByte(Save+0x1DF4) == 0x2C or ReadByte(Save+0x1DF4) == 0x6C then --Post Swim This Way Cutscene
        WriteByte(Save+0x10AE, 0x01)
        BitOr(Save+0x1DF1, 0x03)
        BitOr(Save+0x1DF4, 0x10)
    end
    if ReadShort(Now+0x00) == 0x010B and ReadByte(Save+0x1DF1) == 0x13 then --Pre-Part of Your World Cutscene
        WriteByte(Save+0x1094, 0x00)
        WriteByte(Save+0x10AE, 0x00)
        BitOr(Save+0x1DF1, 0x0C)
        BitOr(Save+0x1DF6, 0x04)
    end
    if ReadShort(Now+0x00) == 0x1A04 and ReadByte(Save+0x1DF1) == 0x9F then --Post Part of Your World Cutscene
        BitOr(Save+0x1DF1, 0x60)
        BitOr(Save+0x2393, 0x20)
    end
    if ReadShort(Now+0x00) == 0x030B and ReadByte(Save+0x1DF2) == 0x02 then --Pre-Under the Sea Cutscene
        WriteByte(Save+0x1094, 0x15)
        BitOr(Save+0x1DF2, 0x01)
    end
    if ReadShort(Now+0x00) == 0x1A04 and ReadByte(Save+0x1DF2) == 0x0B then --Post Under the Sea Cutscene
        BitOr(Save+0x1DF2, 0x04)
        BitOr(Save+0x2393, 0x40)
    end
    if ReadShort(Now+0x00) == 0x020B and ReadShort(Save+0x1DF2) == 0x010F then --Before Ursula's Revenge Cutscene
        BitOr(Save+0x1DF2, 0xF0)
        BitOr(Save+0x1DF7, 0x01)
    end
    if ReadShort(Now+0x00) == 0x090B and ReadByte(Save+0x1DF5) == 0xC1 then --Pre-Ursula's Revenge Cutscene
        WriteByte(Save+0x10B2, 0x03)
        BitOr(Save+0x1DF3, 0x0C)
        BitOr(Save+0x1DF5, 0x02)
    end
    if ReadShort(Now+0x00) == 0x090B and ReadShort(CutLen) == 0x05E1 then --Post Ursula's Revenge Cutscene
        WriteByte(CutSkp, 0x01)
        BitOr(Save+0x1DF5, 0x0C)
        BitOr(Save+0x2393, 0x80)
	end
    if ReadShort(Now+0x00) == 0x040B and ReadByte(Save+0x1DF3) == 0x2D then --Pre-A New Day is Dawning Cutscene
        WriteByte(Save+0x1094, 0x00)
        WriteByte(Save+0x10B2, 0x00)
        WriteByte(Save+0x10B8, 0x00)
        BitOr(Save+0x1DF3, 0x80)
    end
    if ReadShort(CutLen) == 0x0A46 then --Post A New Day is Dawning Cutscene
        WriteByte(CutSkp, 0x01)
    end
end