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
        //                 "fromDate": {
        //                     "type": "string",
        //                     "description": "The starting date for booking."
        //                 },
        //                 "toDate": {
        //                     "type": "string",
        //                     "description": "The ending date for booking."
        //                 },
        //             },
        //             "required": ["hotel"]
        //         }
        //     }
        //  }

        // describe the function
        ToolJObj.Add('type', 'function');
        FunctionJObject.Add('name', 'GetHotelInfo');
        FunctionJObject.Add('description', 'Returns the information about a hotel and booking options.');

        // describe the parameters
        ParametersJObject.Add('type', 'object');

        // describe the hotel parameter
        HotelJObject.Add('type', 'string');
        HotelJObject.Add('description', 'The name of the hotel.');
        PropertiesJObject.Add('hotel', HotelJObject);

        // describe the fromDate parameter
        FromDateJObject.Add('type', 'string');
        FromDateJObject.Add('description', 'The starting date for booking.');
        PropertiesJObject.Add('fromDate', FromDateJObject);

        // describe the toDate parameter
        ToDateJObject.Add('type', 'string');
        ToDateJObject.Add('description', 'The ending date for booking.');
        PropertiesJObject.Add('toDate', ToDateJObject);

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
        FromDate: Date;
        ToDate: Date;
        HotelInfo: TextBuilder;
    begin
        ExtractArguments(Arguments, HotelName, FromDate, ToDate);
        FindHotelInformation(HotelName, FromDate, ToDate, HotelInfo);
        exit(HotelInfo.ToText());
    end;

    procedure GetName(): Text
    begin
        exit('GetHotelInfo')
    end;

    local procedure ExtractArguments(Arguments: JsonObject; var HotelName: Text; var FromDate: Date; var ToDate: Date)
    var
        Token: JsonToken;
    begin
        if not Arguments.Get('hotel', Token) then
            exit;

        HotelName := Token.AsValue().AsText();

        if Arguments.Get('fromDate', Token) then
            FromDate := Token.AsValue().AsDate();

        if Arguments.Get('toDate', Token) then
            ToDate := Token.AsValue().AsDate();
    end;

    local procedure FindHotelInformation(HotelName: Text; FromDate: Date; ToDate: Date; var HotelInfo: TextBuilder)
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
            HotelInfo.AppendLine('## Hotel Information');
            HotelInfo.AppendLine(Hotel.Name);
            HotelInfo.AppendLine(Hotel.City);
            HotelInfo.AppendLine('Rating: ' + Format(Hotel.Rating));
            HotelInfo.AppendLine(Hotel.Amenities);
            HotelInfo.AppendLine('Room Price ($): ' + Format(Hotel.Price));

            FindAvailabilityInformation(Hotel.Code, FromDate, ToDate, HotelInfo);
        until Hotel.Next() = 0;
    end;

    local procedure FindAvailabilityInformation(HotelCode: Code[20]; FromDate: Date; ToDate: Date; var HotelInfo: TextBuilder)
    var
        HotelReservation: Record "GPT Hotel Reservation";
    begin
        HotelInfo.AppendLine('## Availability');
        HotelInfo.AppendLine(StrSubstNo('As of %1, the hotel is: ', FromDate));

        HotelReservation.SetRange("Hotel Code", HotelCode);
        HotelReservation.SetFilter("Check-In Date", '<%1', ToDate);
        HotelReservation.SetFilter("Check-Out Date", '>%1', FromDate);
        if HotelReservation.IsEmpty then
            HotelInfo.Append('available')
        else
            HotelInfo.Append('not available');
    end;
}