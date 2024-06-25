table 50301 "GPT Hotel"
{
    Caption = 'Hotel';

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; City; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(4; Rating; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; Amenities; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(6; Price; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}