table 50302 "GPT Hotel Reservation"
{
    Caption = 'Hotel Reservation';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Reservation Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Hotel Code"; Code[20])
        {
            DataClassification = CustomerContent;
            tableRelation = "GPT Hotel"."Code";
        }
        field(3; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            tableRelation = "Customer"."Name";
        }
        field(4; "Check-In Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Check-Out Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Number of Rooms"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Reservation Code")
        {
            Clustered = true;
        }
    }
}