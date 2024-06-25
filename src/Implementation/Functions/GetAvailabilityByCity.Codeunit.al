codeunit 50303 "GPT GetAvailabilityByCity" implements "AOAI Function"
{
    procedure GetPrompt() ToolJObj: JsonObject
    var
        FunctionJObject: JsonObject;
        ParametersJObject: JsonObject;
        PropertiesJObject: JsonObject;
        CityJObject: JsonObject;
        MinPriceJObject: JsonObject;
        FromDateJObject: JsonObject;
        ToDateJObject: JsonObject;
        RequiredArray: JsonArray;
    begin
        // {
        //     "type": "function",
        //     "function": {
        //         "name": "GetAvailabilityByCity",
        //         "description": "Find available hotels in the city.",
        //         "parameters": {
        //             "type": "object",
        //             "properties": {
        //                 "City": {
        //                     "type": "string",
        //                     "description": "The name of the city."
        //                 },
        //                 "minPrice": {
        //                     "type": "number",
        //                     "description": "The minimum price for a room."
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
        //             "required": ["city", "fromDate"]
        //         }
        //     }
        // }

        // describe the function
        ToolJObj.Add('type', 'function');
        FunctionJObject.Add('name', 'GetAvailabilityByCity');
        FunctionJObject.Add('description', 'Find available hotels in the city.');

        // describe the parameters
        ParametersJObject.Add('type', 'object');

        // describe the city parameter
        CityJObject.Add('type', 'string');
        CityJObject.Add('description', 'The name of the city.');
        PropertiesJObject.Add('city', CityJObject);

        // describe the minPrice parameter
        MinPriceJObject.Add('type', 'number');
        MinPriceJObject.Add('description', 'The minimum price for a room.');
        PropertiesJObject.Add('minPrice', MinPriceJObject);

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
        RequiredArray.Add('city');
        RequiredArray.Add('fromDate');
        ParametersJObject.Add('required', RequiredArray);

        // add the parameters to the function
        FunctionJObject.Add('parameters', ParametersJObject);

        // add the function to the tool
        ToolJObj.Add('function', FunctionJObject);
    end;

    procedure Execute(Arguments: JsonObject): Variant
    var
        City: Text;
        MinPrice: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        ExtractArguments(Arguments, City, MinPrice, FromDate, ToDate);
        exit(FindAvailableHotels(City, MinPrice, FromDate, ToDate));
    end;

    procedure GetName(): Text
    begin
        exit('GetAvailabilityByCity');
    end;

    local procedure ExtractArguments(Arguments: JsonObject; var City: Text; var MinPrice: Decimal; var FromDate: Date; var ToDate: Date)
    var
        Token: JsonToken;
    begin
        if not Arguments.Get('city', Token) then
            exit;
        City := Token.AsValue().AsText();

        if not Arguments.Get('fromDate', Token) then
            exit;
        FromDate := Token.AsValue().AsDate();

        if Arguments.Get('toDate', Token) then
            ToDate := Token.AsValue().AsDate();

        if Arguments.Get('minPrice', Token) then
            MinPrice := Token.AsValue().AsDecimal();
    end;

    local procedure FindAvailableHotels(City: Text; MinPrice: Decimal; FromDate: Date; ToDate: Date): Text;
    var
        Hotel: Record "GPT Hotel";
        HotelReservation: Record "GPT Hotel Reservation";
        AvailableHotels: TextBuilder;
    begin
        AvailableHotels.AppendLine('Available hotels in ' + City + ' from ' + Format(FromDate) + ' to ' + Format(ToDate) + ':');
        AvailableHotels.AppendLine();

        Hotel.SetRange(City, City);
        if MinPrice > 0 then
            Hotel.SetFilter(Price, '<=%1', MinPrice);

        if Hotel.FindSet() then
            repeat
                HotelReservation.SetRange("Hotel Code", Hotel.Code);
                HotelReservation.SetFilter("Check-In Date", '<%1', ToDate);
                HotelReservation.SetFilter("Check-Out Date", '>%1', FromDate);
                if HotelReservation.IsEmpty then
                    AvailableHotels.AppendLine(Hotel.Name);
            until Hotel.Next() = 0;

        exit(AvailableHotels.ToText());
    end;
}