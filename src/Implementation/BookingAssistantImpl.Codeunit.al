codeunit 50301 "GPT Booking Assistant Impl."
{
    procedure GetAnswer(Question: Text; var Answer: Text)
    var
        AzureOpenAI: Codeunit "Azure OpenAi";
        CopilotSetup: Record "GPT Booking Copilot Setup";

        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        GetHotelInfo: Codeunit "GPT GetHotelInfo";
        GetAvailabilityByCity: Codeunit "GPT GetAvailabilityByCity";

        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIFunctionResponse: Codeunit "AOAI Function Response";
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"GPT Booking Copilot") then
            exit;

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"GPT Booking Copilot");
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", CopilotSetup.GetEndpoint(), CopilotSetup.GetDeployment(), CopilotSetup.GetSecretKey());

        AOAIChatCompletionParams.SetTemperature(0);

        AOAIChatMessages.AddTool(GetHotelInfo);
        AOAIChatMessages.AddTool(GetAvailabilityByCity);
        AOAIChatMessages.SetToolChoice('auto');

        AOAIChatMessages.SetPrimarySystemMessage(GetSystemMetaprompt());
        AOAIChatMessages.AddUserMessage(Question);

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if not AOAIOperationResponse.IsSuccess() then
            Error(AOAIOperationResponse.GetError());

        if AOAIOperationResponse.IsFunctionCall() then begin
            AOAIFunctionResponse := AOAIOperationResponse.GetFunctionResponse();
            if AOAIFunctionResponse.IsSuccess() then
                Answer := GenerateFinalResponse(AzureOpenAI, AOAIChatMessages, AOAIChatCompletionParams, AOAIFunctionResponse);
        end else
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
        exit(SystemMetaprompt.ToText());
    end;

    local procedure GenerateFinalResponse(AzureOpenAI: Codeunit "Azure OpenAi"; AOAIChatMessages: Codeunit "AOAI Chat Messages"; AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params"; AOAIFunctionResponse: Codeunit "AOAI Function Response"): Text
    var
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
    begin
        case
            AOAIFunctionResponse.GetFunctionName() of
            'GetHotelInfo':
                begin
                    AOAIChatMessages.ClearTools();

                    AOAIChatMessages.AddToolMessage(AOAIFunctionResponse.GetFunctionId(), AOAIFunctionResponse.GetFunctionName(), AOAIFunctionResponse.GetResult());
                    AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

                    if not AOAIOperationResponse.IsSuccess() then
                        Error(AOAIOperationResponse.GetError());

                    exit(AOAIChatMessages.GetLastMessage());
                end;
            'GetAvailabilityByCity':
                exit(AOAIFunctionResponse.GetResult());
        end;
    end;
}