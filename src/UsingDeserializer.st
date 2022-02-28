USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Json;

{TestFixture}
Class UsingDeserializer
    VAR protected
        deserializer : Deserializer;
        buffer : ARRAY[0..999] OF CHAR;

        JSON_Entry: STRING;
        key: STRING;
        len:DINT;
        keyFound: BOOL;

    END_VAR

    {Test}
    Method Public GetValue_BASIC_DATA_TYPES
        VAR 
            stringValue: STRING;
            usintValue: USINT;
            intValue: INT;
        END_VAR

        //Getting JSON and convert it to ARRAY OF CHAR
        JSON_Entry := '{ "key1": "stringValue", "key2": 10, "key3": 1234, "key4": "1234"}';
        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);


        //testcomment
        //Give it to the deserializer
        deserializer.SetBuffer(REF(buffer));

        //Parse string
        key:= 'key1';
        keyFound := deserializer.TryParse( key, stringValue);

        Equal(keyFound, TRUE);
        Equal(stringValue, 'stringValue');

        //Parse usint
        key:= 'key2';
        keyFound := deserializer.TryParse( key, usintValue);

        Equal(keyFound, TRUE);
        Equal(usintValue, usint#10);

        //Parse int
        key:= 'key3';
        keyFound := deserializer.TryParse( key, intValue);

        Equal(keyFound, TRUE);
        Equal(intValue, 1234);

        //FailedParsing
        key:= 'Not a key';
        keyFound := deserializer.TryParse( key, intValue);

        Equal(keyFound, FALSE);
        Equal(intValue, 0);

        //Parse foreign datatypes int to string -> possible
        key:= 'key2';
        keyFound := deserializer.TryParse( key, stringValue);

        Equal(keyFound, TRUE);
        Equal(stringValue, '10');

        //Parse foreign datatypes string to int -> possible if string is a int
        key:= 'key4';
        keyFound := deserializer.TryParse( key, intValue);

        Equal(keyFound, TRUE);
        Equal(intValue, 1234);

         //Parse foreign datatypes string to int -> False if string is not a int
         key:= 'key1';
         keyFound := deserializer.TryParse( key, intValue);

         Equal(keyFound, FALSE);
         Equal(intValue, 0);
    END_Method


    {Test}
    Method Public GetValue_ARRAY
        VAR 
            stringValue: STRING;
        END_VAR

        JSON_Entry := '{ "arraykey": [1234, 5678]}';

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key:= 'arraykey';
        keyFound := deserializer.TryParse( key, stringValue);

        Equal(keyFound, TRUE);
        Equal(stringValue, '[1234, 5678]');
    END_Method


    {Test}
    Method Public GetValue_Nested
        VAR 
            stringValue: STRING;
            keyArray: ARRAY[0..1] OF STRING;
        END_VAR

        JSON_Entry := '{ "key1": {"nestedkey1": "nested value", "nestedkey2": 456}}';

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));


        //Parse string
        key:= 'key1';
        keyFound := deserializer.TryParse( key, stringValue);

        Equal(keyFound, TRUE);
        Equal(stringValue, '{"nestedkey1": "nested value", "nestedkey2": 456}'); //right now there is a 254 character limit!


        //Get Values from a nested element
        keyArray[0] := 'key1';
        keyArray[1] := 'nestedkey1';

        keyFound := deserializer.TryParse( keyArray, stringValue);

        Equal(keyFound, TRUE);
        Equal(stringValue, 'nested value');
    END_Method


    {Test}
    Method Public GetValue_Nested_in_Nested
        VAR 
            stringValue: STRING;
            keyArray: ARRAY[0..2] OF STRING;
            intValue: INT;
        END_VAR

        JSON_Entry := '{ "key1": {"nestedkey1": "nested value", "nestedkey2": {"nested_nested_key" : 1234}}}';

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        //Get Values from a nested element
        keyArray[0] := 'key1';
        keyArray[1] := 'nestedkey2';
        keyArray[2] := 'nested_nested_key';

        keyFound := deserializer.TryParse( keyArray, intValue);

        Equal(keyFound, TRUE);
        Equal(intValue, 1234);
    END_Method


END_CLASS