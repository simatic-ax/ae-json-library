USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;
USING Siemens.Simatic.S71500.Clocks;

PROGRAM MyProgram
    VAR_EXTERNAL
        ActiveStep : STRING;
        SerializedDocument1 : STRING;
        TimeCreationDocument1 : LINT;
        ParsedValue1 : INT;
        SerializedDocument2 : STRING;
        TimeCreationDocument2 : LINT;
        ParsedValue2 : DINT;
    END_VAR
    VAR
        measurement : RuntimeMeasurement;
        timeOfOperations : LTIME;
        doc : JsonDocument;
        cmpBuff : ARRAY[0..20] OF CHAR;
        myBoolean : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
        myInt : JsonInt := (Value := 1234, Key := 'myInt');
        myDint : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
        myObject : JsonObject := (Key := 'myObject');
        step : Steps;
        deserializer : Deserializer;
        keyFound : BOOL;
        keyArray : ARRAY[0..1] OF STRING := ['myObject', 'myDint'];
    END_VAR

    CASE step OF
        Steps#CreateDocument1:
            // Create Document 1st object model
            // Expected Value: {"myInt": 1234}
            ActiveStep := 'Create JSON Document {"myInt": 1234}';
            doc.AddElement(myInt);
            doc.Serialize(doc.buffer);
            step := Steps#SerializeDocument1
            ;
        Steps#SerializeDocument1:
            // Serialize Document 1st object model1
            ActiveStep := 'Serialize JSON Document {"myInt": 1234}';
            measurement.Start();
            doc.Serialize(doc.buffer);
            timeOfOperations := measurement.Stop();
            SerializedDocument1 := Arrays.ToString(doc.buffer);
            TimeCreationDocument1 := measurement.GetElapsedNanoseconds();
            step := Steps#ParseDocument1
            ;
        Steps#ParseDocument1:
            // Parse Document 1st object model
            ActiveStep := 'Parse for "myInt" JSON Document {"myInt": 1234}';
            deserializer.SetBuffer(REF(doc.buffer));
            keyFound := deserializer.TryParse('myInt', ParsedValue1);
            step := Steps#ResetJSonDocument1
            ;
        Steps#ResetJSonDocument1:
            // ResetJSonDocument 1st object model
            ActiveStep := 'Reset JSON Document {"myInt": 1234}';
            doc.Reset();
            step := Steps#CreateDocument2
            ;
        Steps#CreateDocument2:
            // Create nested JSON document which looks like:
            // {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}
            ActiveStep := 'Create JSON Document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}';
            myObject.AddElement(myInt);
            myObject.AddElement(myDint);
            doc.AddElement(myBoolean);
            doc.AddElement(myObject);
            step := Steps#SerializeDocument2
            ;
        Steps#SerializeDocument2:
            // Serialize the document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}
            ActiveStep := 'Serialize JSON Document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}';
            measurement.Start();
            doc.Serialize(doc.buffer);
            timeOfOperations := measurement.Stop();
            SerializedDocument2 := Arrays.ToString(doc.buffer);
            TimeCreationDocument2 := measurement.GetElapsedNanoseconds();
            step := Steps#ParseDocument2;
            ;
        Steps#ParseDocument2:
            // Parse Document for the value of the nested key `myObject.myDint` and expect `12345678`
            // Get Values from a nested element
            ActiveStep := 'Parse for "myInt" JSON Document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}';
            deserializer.SetBuffer(REF(doc.buffer));
            keyFound := deserializer.TryParse(keyArray, ParsedValue2);
            step := Steps#ResetJSonDocument2;
            ;
        Steps#ResetJSonDocument2:
            // ResetJSonDocument 2nd configuration
            ActiveStep := 'Reset JSON Document {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}';
            doc.Reset();
            step := Steps#CreateDocument1;
            ;
    END_CASE;


END_PROGRAM

TYPE
    Steps : (
        CreateDocument1,
        SerializeDocument1,
        ParseDocument1,
        ResetJSonDocument1,
        CreateDocument2,
        SerializeDocument2,
        ParseDocument2,
        ResetJSonDocument2) := CreateDocument1;
END_TYPE
