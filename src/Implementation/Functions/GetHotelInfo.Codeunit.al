codeunit 50302 "GPT GetHotelInfo" implements "AOAI Function"
{
    procedure GetPrompt() ToolJObj: JsonObject
    var
        FunctionJObject: JsonObject;
        ParametersJObject: JsonObject;
        PropertiesJObject: JsonObject;
        HotelJObject: JsonObject;
        FromDateJObject: JsonObject;
        ToDateJObject: JsonObject;
        RequiredArray: JsonArray;
    begin
        //  {
        //     "type": "function",
        //     "function": {
        //         "name": "GetHotelInfo",
        //         "description": "Returns the information about a hotel and booking options.",
        //         "parameters": {
        //             "type": "object",
        //             "properties": {
        //                 "hotel": {
        //                     "type": "string",
        //                     "description": "The name of the hotel."
        //                 },
        //             },
        //             "required": ["hotel"]
        //         }
        //     }
        //  }

        // describe the function
        ToolJObj.Add('type', 'function');
        FunctionJObject.Add('name', 'GetHotelInfo');
        FunctionJObject.Add('description', 'Returns the information about a hotel.');

        // describe the parameters
        ParametersJObject.Add('type', 'object');

        // describe the hotel parameter
        HotelJObject.Add('type', 'string');
        HotelJObject.Add('description', 'The name of the hotel.');
        PropertiesJObject.Add('hotel', HotelJObject);

        // add the properties to the parameters
        ParametersJObject.Add('properties', PropertiesJObject);

        // describe the required parameters
        RequiredArray.Add('hotel');
        ParametersJObject.Add('required', RequiredArray);

        // add the parameters to the function
        FunctionJObject.Add('parameters', ParametersJObject);

        // add the function to the tool
        ToolJObj.Add('function', FunctionJObject);
    end;

    procedure Execute(Arguments: JsonObject): Variant
    var
        HotelName: Text;
        HotelInfo: TextBuilder;
    begin
        ExtractArguments(Arguments, HotelName);
        FindHotelInformation(HotelName, HotelInfo);
        exit(HotelInfo.ToText());
    end;

    procedure GetName(): Text
    begin
        exit('GetHotelInfo')
    end;

    local procedure ExtractArguments(Arguments: JsonObject; var HotelName: Text)
    var
        Token: JsonToken;
    begin
        if not Arguments.Get('hotel', Token) then
            exit;

        HotelName := Token.AsValue().AsText();
    end;

    local procedure FindHotelInformation(HotelName: Text; var HotelInfo: TextBuilder)
    var
        Hotel: Record "GPT Hotel";
    begin
        Hotel.SetFilter("Name", StrSubstNo('@*%1*', HotelName));
        if Hotel.IsEmpty then begin
            HotelInfo.AppendLine('No hotels are found');
            exit;
        end;

        HotelInfo.AppendLine(StrSubstNo('Found %1 hotels.', Hotel.Count));
        Hotel.FindSet();
        repeat
            HotelInfo.AppendLine('Hotel Information');
            HotelInfo.AppendLine(Hotel.Name);
            HotelInfo.AppendLine(Hotel.City);
            HotelInfo.AppendLine('Rating: ' + Format(Hotel.Rating));
            HotelInfo.AppendLine(Hotel.Amenities);
            HotelInfo.AppendLine('Room Price ($): ' + Format(Hotel.Price));
        until Hotel.Next() = 0;
    end;
}