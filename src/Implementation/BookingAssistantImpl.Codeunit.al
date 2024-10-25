codeunit 50301 "GPT Booking Assistant Impl."
{
    procedure GetAnswer(Question: Text; var Answer: Text)
    var
        // Azure OpenAI
        AzureOpenAI: Codeunit "Azure OpenAi";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIDeployments: codeunit "AOAI Deployments";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";

        // Tools
        GetHotelInfo: Codeunit "GPT GetHotelInfo";
        GetAvailabilityByCity: Codeunit "GPT GetAvailabilityByCity";
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"GPT Booking Copilot") then
            exit;

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"GPT Booking Copilot");
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", AOAIDeployments.GetGPT4oLatest());

        AOAIChatCompletionParams.SetTemperature(0);

        AOAIChatMessages.AddTool(GetHotelInfo);
        AOAIChatMessages.AddTool(GetAvailabilityByCity);
        AOAIChatMessages.SetToolInvokePreference(Enum::"AOAI Tool Invoke Preference"::"Automatic");
        AOAIChatMessages.SetToolChoice('auto');

        AOAIChatMessages.SetPrimarySystemMessage(GetSystemMetaprompt());
        AOAIChatMessages.AddUserMessage(Question);

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if not AOAIOperationResponse.IsSuccess() then
            Error(AOAIOperationResponse.GetError());

        Answer := AOAIChatMessages.GetLastMessage();
    end;

    local procedure GetSystemMetaprompt(): Text
    var
        SystemMetaprompt: TextBuilder;
    begin
        SystemMetaprompt.AppendLine('You are the hotels booking assistant.');
        SystemMetaprompt.AppendLine('Select one of the following functions to resolve the user query:');
        SystemMetaprompt.AppendLine('1. GetHotelInfo: to get information about a hotel.');
        SystemMetaprompt.AppendLine('2. GetAvailabilityByCity: to get available hotels in a city.');
        SystemMetaprompt.AppendLine('In case user asks for something else, don''t answer and ask to rephrase the question.');
        SystemMetaprompt.AppendLine('When you get the information from the function(-s), summarize it in a nice user friendly answer and respond in HTML format.');
        exit(SystemMetaprompt.ToText());
    end;
}