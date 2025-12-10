local UIS = game:GetService("UserInputService")

UIS.TouchTap:Connect(function(tapPositions, processed)
    if processed then return end

    -- simulate a left mouse click
    UIS.InputBegan:Fire({
        UserInputType = Enum.UserInputType.MouseButton1,
        UserInputState = Enum.UserInputState.Begin,
        Position = tapPositions[1]
    }, false)

    UIS.InputEnded:Fire({
        UserInputType = Enum.UserInputType.MouseButton1,
        UserInputState = Enum.UserInputState.End,
        Position = tapPositions[1]
    }, false)
end)

print("HI BITCH IM DOING THE MOBIEL SCIRPT LIKE FUCKIG NOW")
task.wait(2)
loadstring(game:HttpGet(('https://raw.githubusercontent.com/azureblueday/astrahub/refs/heads/main/astra59.luau')))()
